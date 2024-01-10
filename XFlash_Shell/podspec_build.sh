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
    printf '\033[1;37;40m[DEBUG] %b\033[0m\n' "$*";
}

Red_Error() {
    printf '\033[1;31;40m[ERROR] %b\033[0m\n' "$*";
    exit 1
}

# ==================== 标志校验 ==================== #

Check_parameter() {
    variable=$(eval echo '$'$2)
    if [ !$1 ] || [ -n "$variable" ]; then
        Blue_Info "$2 = $variable"
    else
        Red_Error "请填写$2"
    fi
}

# ==================== 打印参数 ==================== #

# 编译项目
current_work_dir=$(pwd)
project_name="XXX"
workspace_name="Example/${project_name}.xcworkspace"
scheme_name=${project_name}
build_version="1.0.0"

# 输出目录
build_dir="Example/build"
out_dir="Example/out"
final_framework_dir="${project_name}/Frameworks"

# xcframework
xcframework_iphoneos="${build_dir}/Release-iphoneos.xcarchive/Products/Library/Frameworks/${project_name}.framework"
xcframework_iphonesimulator="${build_dir}/Release-iphonesimulator.xcarchive/Products/Library/Frameworks/${project_name}.framework"
xcframework_name="${project_name}.xcframework"

Check_parameter true    "current_work_dir"
Check_parameter true    "workspace_name"
Check_parameter true    "scheme_name"
Check_parameter true    "build_version"
Check_parameter true    "xcframework_name"

Check_parameter true    "build_dir"
Check_parameter true    "out_dir"
Check_parameter true    "final_framework_dir"

function build_clean {
    Green_Success "--------------------开始清理项目--------------------"
    
    rm -rf ${build_dir}
    rm -rf ${out_dir}
    
    Green_Success "--------------------完成清理项目--------------------"
}

function build_framework {
    Green_Success "--------------------开始编译framework--------------------"
    
    xcodebuild archive \
    -workspace ${workspace_name} \
    -scheme ${scheme_name} \
    -destination "generic/platform=iOS" \
    -sdk "iphoneos" \
    -archivePath "${build_dir}/Release-iphoneos" \
    SKIP_INSTALL=NO \
    BUILD_LIBRARY_FOR_DISTRIBUTION=YES \
    build || exit 1
    
    white_Print "--------------------真机架构编译成功--------------------"
    
    xcodebuild archive \
    -workspace ${workspace_name} \
    -scheme ${scheme_name} \
    -destination "generic/platform=iOS Simulator" \
    -sdk "iphonesimulator" \
    -archivePath "${build_dir}/Release-iphonesimulator" \
    SKIP_INSTALL=NO \
    BUILD_LIBRARY_FOR_DISTRIBUTION=YES \
    build || exit 1
    
    white_Print "--------------------模拟器架构编译成功--------------------"
    
    Green_Success "--------------------结束编译framework--------------------"
}

function build_fat_framework {
    Green_Success "--------------------开始合并framework--------------------"
    
    Yellow_Warning "静态库不需要dSYM"
    Yellow_Warning "debug-symbols请用绝对路径!!!"

    mkdir -p ${out_dir}/
            
    xcodebuild -create-xcframework \
    -framework $xcframework_iphoneos \
    -framework $xcframework_iphonesimulator \
    -output ${out_dir}/${xcframework_name} || exit 1
#    -debug-symbols $dSYMs_iphoneos
#    -debug-symbols $dSYMs_iphonesimulator
    
    Green_Success "--------------------结束合并framework--------------------"
}

function store_final_framework {
    Green_Success "--------------------开始拷贝framework--------------------"
    
    if [ -d ${final_framework_dir} ]; then
        white_Print "${final_framework_dir}不为空，准备清空"
        rm -R ${final_framework_dir}
        white_Print "已清空${final_framework_dir}"
    fi
    
    mkdir ${final_framework_dir}
    cp -R ${out_dir}/${xcframework_name} ${final_framework_dir}
    
    Green_Success "--------------------完成拷贝framework--------------------"
}

function reset_podspec_version {
    Green_Success "--------------------开始设置Version--------------------"
    
    old_build_version=`grep -E 's.version.*=' ${project_name}.podspec | tr -d "'a-z= " | sed "s/\.//1"`
    white_Print "old_build_version:${old_build_version}"
    
    sed -i '' "s/${old_build_version}/${build_version}/g" ${project_name}.podspec
    sed -i '' "s/${old_build_version}/${build_version}/g" ${project_name}_Binary.podspec
    white_Print "new_build_version:${build_version}"
    
    Green_Success "--------------------完成设置Version--------------------"
}

function detect_code_commit {
    Green_Success "--------------------开始推送Git--------------------"
    
    git add .
    git commit -m "build: ${build_version}"
    git push --set-upstream origin
    
    Green_Success "--------------------完成推送Git--------------------"
}

function push_tag {
    Green_Success "--------------------开始推送Tag--------------------"
    
    git tag "${build_version// /.}"
    git push origin --tags
    
    Green_Success "--------------------完成推送Tag--------------------"
}

function publish_podspec {
    Green_Success "--------------------开始发布Podspec--------------------"
    
    pod repo push LetalkSpec "${project_name}.podspec" --use-libraries --allow-warnings --skip-import-validation --skip-tests --verbose
    white_Print "--------------------代码源发布成功--------------------"
        
    pod repo push LetalkSpec "${project_name}_Binary.podspec" --use-libraries --allow-warnings --skip-import-validation --skip-tests --verbose
    white_Print "--------------------二进制源发布成功--------------------"
    
    Green_Success "--------------------完成发布Podspec--------------------"
}

# 组件二进制
build_clean
build_framework
build_fat_framework
store_final_framework

# 修改podspec
reset_podspec_version

# push-git
detect_code_commit
push_tag

# push-spec
publish_podspec
