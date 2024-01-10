# ==================== 标志打印 ==================== #
Green_Success() {
    printf '\033[1;32;40m[SUCCESS] %b\033[0m\n' "$*";
}

Blue_Info() {
    printf '\033[1;34;40m[INFO] %b\033[0m\n' "$*";
}

Yellow_Warning() {
    printf '\033[1;33;40m[WARNING] %b\033[0m\n' "$*";
}

white_Print() {
    printf '\033[1;37;40m[ERROR] %b\033[0m\n' "$*";
}

Red_Error() {
    printf '\033[1;31;40m[ERROR] %b\033[0m\n' "$*";
    exit 1
}

# ==================== 需要填写的参数 ==================== #

echo "请选择打包方式 ? [1:Debug 2:Enterprise_release 3:Ad_hoc 4:App_store]"

read number
while([[ $number != 1 ]] && [[ $number != 2 ]] && [[ $number != 3 ]] && [[ $number != 4 ]]); do
    Yellow_Warning "Should enter 1 or 2 or 3 or 4"
    echo "请选择打包方式 ? [1:Debug 2:Enterprise_release 3:Ad_hoc 4:App_store]"
    read number
done

if [ $number != 4 ]; then
    echo "请选择上传市场 ? [1:蒲公英 2:Fir 3:导出IPA]"

    read market
    while([[ $market != 1 ]] && [[ $market != 2 ]] && [[ $market != 3 ]]); do
        Yellow_Warning "Should enter 1 or 2 or 3"
        echo "请选择上传市场 ? [1:蒲公英 2:Fir 3:导出IPA]"
        read market
    done
else
    echo "请选择上传市场 ? [1:App_store 2:导出IPA]"

    read market
    while([[ $market != 1 ]] && [[ $market != 2 ]]); do
        Yellow_Warning "Should enter 1 or 2 or 3"
        echo "请选择上传市场 ? [1:App_store 2:导出IPA]"
        read market
    done

    market=$[ $market + 3 ]
fi

# .xcworkspace的名字（必填）
workspace_name="TeamTalk"

# 指定项目的scheme/target名称（必填）
scheme_name="LeTalk"

# 指定要打包编译的方式（必填）
build_configuration=""

# 打包的方式（必填）
method=""

# 证书名称（手动管理时必填）
mobileprovision_name=""
# mobileprovision_name="9d8c7290-4345-4ebf-82d4-a74cab2ea40b"

# bundleID（手动管理时必填）
bundle_identifier=""

# 根据选项配置不同的包
if [ $number == 1 ]; then
    build_configuration="Debug"
    method="development"
elif [[ $number == 2 ]]; then
    build_configuration="Release"
    method="enterprise"
elif [[ $number == 3 ]]; then
    build_configuration="Debug"
    method="ad-hoc"
else
    build_configuration="Release"
    method="app-store"
fi

echo "--------------------打包参数配置--------------------"
Check_parameter() {
    variable=$(eval echo '$'$2)
    if [ !$1 ] || [ -n "$variable" ]; then
        Blue_Info "$2 = $variable"
    else
        Red_Error "请填写$2"
    fi
}

Check_parameter true    "workspace_name"
Check_parameter true    "scheme_name"
Check_parameter true    "build_configuration"
Check_parameter true    "method"
Check_parameter false   "mobileprovision_name"
Check_parameter false   "bundle_identifier"

# ==================== 固定路径 ==================== #

# 工程根目录
project_dir="$( cd "$( dirname "$0"  )" && pwd  )"
# 指定输出文件夹路径
export_path="$project_dir/Build"
# 指定归档文件路径
export_archive_path="$export_path/$scheme_name.xcarchive"
# 指定ipa名称
export_ipa_name="$scheme_name.ipa"
# 指定ipa文件夹路径
export_ipa_path="$export_path/$export_ipa_name"
# 指定plist配置文件的路径
export_plist_path="$project_dir/ExportOptions.plist"

echo "--------------------打包路径配置--------------------"

Check_parameter true    "project_dir"
Check_parameter true    "export_path"
Check_parameter true    "export_archive_path"
Check_parameter true    "export_ipa_name"
Check_parameter true    "export_ipa_path"
Check_parameter true    "export_plist_path"

# ==================== 自动打包 ==================== #

echo "--------------------开始清理项目--------------------"

if [ -d "$export_path" ];then
    rm -rf $export_path
fi

# 编译前清理工程
xcodebuild clean -workspace ${workspace_name}.xcworkspace \
                 -scheme ${scheme_name} \
                 -configuration ${build_configuration} \
                 -quiet

echo "--------------------开始构建项目--------------------"

xcodebuild archive -workspace ${workspace_name}.xcworkspace \
                   -scheme ${scheme_name} \
                   -configuration ${build_configuration} \
                   -archivePath ${export_archive_path} \
                   -destination 'generic/platform=iOS' \
                   -quiet

# 检查是否构建成功
if [ -d "$export_archive_path" ] ; then
    Green_Success "项目构建成功"
else
    Red_Error "项目构建失败"
fi

echo "--------------------开始导出IPA--------------------"

# 根据参数生成export_options_plist文件
/usr/libexec/PlistBuddy -c  "Add :method String ${method}"  $export_plist_path
/usr/libexec/PlistBuddy -c  "Add :provisioningProfiles:"  $export_plist_path
/usr/libexec/PlistBuddy -c  "Add :provisioningProfiles:${bundle_identifier} String ${mobileprovision_name}"  $export_plist_path
/usr/libexec/PlistBuddy -c  "Add :compileBitcode bool NO" $export_plist_path

xcodebuild  -exportArchive \
            -archivePath ${export_archive_path} \
            -exportPath ${export_path} \
            -exportOptionsPlist ${export_plist_path} \
            -allowProvisioningUpdates \
            -quiet

# 检查IPA

if [ -f $export_ipa_path ] ; then
    Green_Success "导出IPA成功"
else
    Red_Error "导出IPA失败"
fi

# 清空plist文件
if [ -f "$export_plist_path" ] ; then
    rm -f $export_plist_path
fi

# 输出打包总用时
Blue_Info "本次脚本打包总用时：${SECONDS}s"

if [ $market == 1 ]; then

    echo "--------------------蒲公英参数配置--------------------"

    api_key="2a64c1c8b90a6ae242f37d9ab695e1f0"

    Check_parameter true    "api_key"

    echo "--------------------获取上传凭证--------------------"

    command="curl -s \
            --form-string "_api_key=$api_key" \
            --form-string "buildType=ipa" http://www.pgyer.com/apiv2/app/getCOSToken"
    result=$(eval $command)

    [[ "${result}" =~ \"endpoint\":\"([\:\_\.\/\\A-Za-z0-9\-]+)\" ]] && endpoint=`echo ${BASH_REMATCH[1]} | sed 's!\\\/!/!g'`
    [[ "${result}" =~ \"key\":\"([\.a-z0-9]+)\" ]] && key=`echo ${BASH_REMATCH[1]}`
    [[ "${result}" =~ \"signature\":\"([\=\&\_\;A-Za-z0-9\-]+)\" ]] && signature=`echo ${BASH_REMATCH[1]}`
    [[ "${result}" =~ \"x-cos-security-token\":\"([\_A-Za-z0-9\-]+)\" ]] && x_cos_security_token=`echo ${BASH_REMATCH[1]}`

    if [ -z "$key" ] || [ -z "$signature" ] || [ -z "$x_cos_security_token" ] || [ -z "$endpoint" ]; then
        Red_Error "获取上传凭证失败"
    else
        Green_Success "获取上传凭证成功"
    fi

    echo "--------------------上传IPA文件--------------------"

    command="curl -s -o /dev/null -w '%{http_code}' \
            --form-string 'key=${key}' \
            --form-string 'signature=${signature}' \
            --form-string 'x-cos-security-token=${x_cos_security_token}' \
            --form-string 'x-cos-meta-file-name=${scheme_name}.ipa' \
            -F 'file=@${export_ipa_path}' ${endpoint}"
    result=$(eval $command)

    if [ $result -ne 204 ]; then
        Red_Error "上传IPA文件失败"
    else
        Green_Success "上传IPA文件成功"
    fi

    echo "--------------------检查上传结果--------------------"

    command="curl -s http://www.pgyer.com/apiv2/app/buildInfo?_api_key=${api_key}\&buildKey=${key}"
    for i in {1..60}; do
        Blue_Info "检查中..."
        result=$(eval $command)
        [[ "${result}" =~ \"code\":([0-9]+) ]] && code=`echo ${BASH_REMATCH[1]}`
        [[ "${result}" =~ \"buildQRCodeURL\":\"(.*)\" ]] && buildQRCodeURL=$(echo ${BASH_REMATCH[1]} | sed 's/\\//g')
        if [ $code -eq 0 ]; then
            Green_Success $buildQRCodeURL
            break
        else
            sleep 1
        fi
    done

elif [ $market == 2 ]; then

    Green_Success "FIR"

elif [ $market == 3 ] || [ $market == 5 ]; then

    Green_Success "IPA地址: $export_ipa_path"

elif [ $market == 4 ]; then

    echo "--------------------AppStore参数配置--------------------"

    api_key=""
    issuer_id=""

    Check_parameter true    "api_key"
    Check_parameter true    "issuer_id"

    echo "--------------------开始校验IPA--------------------"

    command="xcrun altool --validate-app \
                          -f ${export_ipa_path} \
                          -t ios \
                          --apiKey ${api_key}
                          --apiIssuer ${issuer_id} \
                          --verbose"
    result=$(eval $command)
    Blue_Info $result

    if [ -z "$result" ]; then
        Red_Error "校验IPA失败"
    else
        Green_Success "校验IPA成功"
    fi

    echo "--------------------开始上传IPA--------------------"

    command="xcrun altool --upload-app \
                          -f ${export_ipa_path} \
                          -t ios --apiKey ${api_key} \
                          --apiIssuer ${issuer_id} \
                          --verbose"
    result=$(eval $command)
    Blue_Info $result
    
    if [ -z "$result" ]; then
        Red_Error "上传IPA失败"
    else
        Green_Success "上传IPA成功"
    fi
fi

exit 0
