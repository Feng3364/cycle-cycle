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

current_work_dir=$(pwd)
project_name="LTPublic"
workspace_name="${project_name}.xcworkspace"
scheme_name=${project_name}
build_xcframework="false"
framework_name="${project_name}.framework"
xcframework_name="${project_name}.xcframework"
build_dir="build"
out_dir="out"
final_framework_dir="../LTPublic/Frameworks"

Check_parameter true    "current_work_dir"
Check_parameter true    "workspace_name"
Check_parameter true    "scheme_name"
Check_parameter true    "build_xcframework"
Check_parameter true    "framework_name"
Check_parameter true    "xcframework_name"
Check_parameter true    "build_dir"
Check_parameter true    "out_dir"
Check_parameter true    "final_framework_dir"

function build_clean {
    Blue_Info "--------------------开始清理项目--------------------"
    
    rm -rf ${build_dir}
    rm -rf ${out_dir}
    
    Green_Success "--------------------完成清理项目--------------------"
}

function build_framework {
    Blue_Info "--------------------开始编译framework--------------------"
    
    xcodebuild \
    -workspace ${workspace_name} \
    -scheme ${scheme_name} \
    -sdk iphoneos \
    -configuration "Release" \
    OTHER_CFLAGS="-fembed-bitcode" \
    BUILD_DIR="../${build_dir}" \
    build || exit 1
    
    xcodebuild \
    -workspace ${workspace_name} \
    -scheme ${scheme_name} \
    -sdk iphonesimulator \
    -configuration "Release" \
    ONLY_ACTIVE_ARCH=NO \
    EXCLUDED_ARCHS="arm64" \
    OTHER_CFLAGS="-fembed-bitcode" \
    BUILD_DIR="../${build_dir}" \
    build || exit 1
    
    Green_Success "--------------------结束编译framework--------------------"
}

function build_fat_framework {
    Blue_Info "--------------------开始合并framework--------------------"

    mkdir -p ${out_dir}/
    
    if [ ${build_xcframework} == "true" ]; then
        xcodebuild -create-xcframework \
        -framework ${build_dir}/Release-iphonesimulator/${project_name}/${framework_name} \
        -framework ${build_dir}/Release-iphoneos/${project_name}/${framework_name} \
        -output ${out_dir}/${xcframework_name} || exit 1
    else
        cp -R ${build_dir}/Release-iphoneos/${project_name}/${framework_name} ${out_dir}
    
        lipo -create \
        ${build_dir}/Release-iphonesimulator/${project_name}/${framework_name}/${project_name} \
        ${build_dir}/Release-iphoneos/${project_name}/${framework_name}/${project_name} \
        -output ${out_dir}/${framework_name}/${project_name} || exit 1
    fi
    
    
    Green_Success "--------------------结束合并framework--------------------"
}

function store_final_framework {
    Blue_Info "--------------------开始拷贝framework--------------------"
    
    if [ -d ${final_framework_dir} ]; then
        white_Print "${final_framework_dir}不为空，准备清空"
        rm -R ${final_framework_dir}
        white_Print "已清空${final_framework_dir}"
    fi
    
    mkdir ${final_framework_dir}
    
    if [ ${build_xcframework} == "true" ]; then
        cp -R ${out_dir}/${xcframework_name} ${final_framework_dir}
    else
        cp -R ${out_dir}/${framework_name} ${final_framework_dir}
    fi
    
    Green_Success "--------------------完成拷贝framework--------------------"
}

build_clean
build_framework
build_fat_framework
store_final_framework

