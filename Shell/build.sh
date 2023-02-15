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

# .xcworkspace的名字（必填）
workspace_name="ComparePic"

# 指定项目的scheme/target名称（必填）
scheme_name="ComparePic"

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
    method="debug"
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

#echo "--------------------打包参数配置--------------------"
#Check_parameter() {
#    variable=$(eval echo '$'$2)
#    if [ !$1 ] || [ -n "$variable" ]; then
#        Blue_Info "$2 = $variable"
#    else
#        Red_Error "请填写$2"
#    fi
#}
#
#Check_parameter true    "workspace_name"
#Check_parameter true    "scheme_name"
#Check_parameter true    "build_configuration"
#Check_parameter true    "method"
#Check_parameter false   "mobileprovision_name"
#Check_parameter false   "bundle_identifier"
#
## ==================== 固定路径 ==================== #
#
## 工程根目录
#project_dir=$(dirname $(realpath $0))
## 指定输出文件夹路径
#export_path="$project_dir/Build"
## 指定归档文件路径
#export_archive_path="$export_path/$scheme_name.xcarchive"
## 指定ipa文件夹路径
#export_ipa_path="$export_path/"
## 指定plist配置文件的路径
#export_plist_path="$project_dir/ExportOptions.plist"
#
#echo "--------------------打包路径配置--------------------"
#
#Check_parameter true    "project_dir"
#Check_parameter true    "export_path"
#Check_parameter true    "export_archive_path"
#Check_parameter true    "export_ipa_path"
#Check_parameter true    "export_plist_path"
#
## ==================== 自动打包 ==================== #
#
#echo "--------------------开始清理项目--------------------"
#
#if [ -f "$export_plist_path" ] ; then
#    rm -f $export_plist_path
#fi
#
## 编译前清理工程
#xcodebuild clean -workspace ${workspace_name}.xcworkspace \
#                 -scheme ${scheme_name} \
#                 -configuration ${build_configuration}
#
#echo "--------------------开始构建项目--------------------"
#
#xcodebuild archive -workspace ${workspace_name}.xcworkspace \
#                   -scheme ${scheme_name} \
#                   -configuration ${build_configuration} \
#                   -archivePath ${export_archive_path} \
#                   # arm芯片需要
#                   -destination 'generic/platform=iOS'
#
## 检查是否构建成功
#if [ -d "$export_archive_path" ] ; then
#    Green_Success "项目构建成功"
#else
#    Red_Error "项目构建失败"
#fi

echo "--------------------开始导出IPA--------------------"

# 根据参数生成export_options_plist文件
/usr/libexec/PlistBuddy -c  "Add :method String ${method}"  $export_plist_path
/usr/libexec/PlistBuddy -c  "Add :provisioningProfiles:"  $export_plist_path
/usr/libexec/PlistBuddy -c  "Add :provisioningProfiles:${bundle_identifier} String ${mobileprovision_name}"  $export_plist_path
/usr/libexec/PlistBuddy -c  "Add :compileBitcode bool NO" $export_plist_path

xcodebuild  -exportArchive \
            -archivePath ${export_archive_path} \
            -exportPath ${export_ipa_path} \
            -exportOptionsPlist ${export_plist_path} \
            -allowProvisioningUpdates YES
            -quited

# 检查IPA
if [ -f "$export_ipa_path/$scheme_name.ipa" ] ; then
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

echo "--------------------开始上传IPA--------------------"

## AppStore上传到xxx
#if [ $number == 4 ];then
#        # 将包上传AppStore
#        ipa_path="$export_ipa_path/$scheme_name.ipa"
#        # 上传AppStore的密钥ID、Issuer ID
#        api_key="xxxxx"
#        issuer_id="xxxxx"
#
#    echo "--------------------AppStore上传固定参数检查--------------------"
#    echo "ipa_path = ${ipa_path}"
#    echo "api_key = ${api_key}"
#    echo "issuer_id = ${issuer_id}"
#
## 校验 + 上传 方式1
#    # # 校验指令
#    # cnt0=`xcrun altool --validate-app -f ${ipa_path} -t ios --apiKey ${api_key} --apiIssuer ${issuer_id} --verbose`
#    # echo $cnt0
#    # cnt=`echo $cnt0 | grep “No errors validating archive” | wc -l`
#
#    # if [ $cnt = 1 ] ; then
#    #     echo "\033[32;1m校验IPA成功🎉  🎉  🎉 \033[0m"
#    #     echo "------------------------------------------------------"
#    #     cnt0=`xcrun altool --upload-app -f ${ipa_path} -t ios --apiKey ${api_key} --apiIssuer ${issuer_id} --verbose"`
#    #     echo $cnt0
#    #     cnt=`echo $cnt0 | grep “No errors uploading” | wc -l`
#    #     if [ $cnt = 1 ] ; then
#    #         echo "\033[32;1m上传IPA成功🎉  🎉  🎉 \033[0m"
#    #         echo "------------------------------------------------------"
#
#    #     else
#    #         echo "\033[32;1m上传IPA失败😢 😢 😢   \033[0m"
#    #         echo "------------------------------------------------------"
#    #     fi
#    # else
#    #     echo "\033[32;1m校验IPA失败😢 😢 😢   \033[0m"
#    #     echo "------------------------------------------------------"
#    # fi
#
## 校验 + 上传 方式2
#    # 验证
#    validate="xcrun altool --validate-app -f ${ipa_path} -t ios --apiKey ${api_key} --apiIssuer ${issuer_id} --verbose"
#    echo "running validate cmd" $validate
#    validateApp="$($validate)"
#    if [ -z "$validateApp" ]; then
#        echo "\033[32m校验IPA失败😢 😢 😢   \033[0m"
#        echo "------------------------------------------------------"
#    else
#        echo "\033[32m校验IPA成功🎉  🎉  🎉  \033[0m"
#        echo "------------------------------------------------------"
#
#        # 上传
#        upload="xcrun altool --upload-app -f ${ipa_path} -t ios --apiKey ${api_key} --apiIssuer ${issuer_id} --verbose"
#        echo "running upload cmd" $upload
#        uploadApp="$($upload)"
#        echo uploadApp
#        if [ -z "$uploadApp" ]; then
#            echo "\033[32m传IPA失败😢 😢 😢   \033[0m"
#            echo "------------------------------------------------------"
#        else
#            echo "\033[32m上传IPA成功🎉  🎉  🎉 \033[0m"
#            echo "------------------------------------------------------"
#        fi
#
#    fi
#
#fi
#
exit 0
