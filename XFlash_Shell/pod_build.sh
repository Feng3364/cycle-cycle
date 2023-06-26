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

# ==================== 标志校验 ==================== #

Check_parameter() {
    variable=$(eval echo '$'$2)
    if [ !$1 ] || [ -n "$variable" ]; then
        Blue_Info "$2 = $variable"
    else
        Red_Error "请填写$2"
    fi
}

# ==================== 需要填写的参数 ==================== #

lint="本地校验"
remote="远程校验"
push="远程发布"

echo "请选择操作方式 ? [1:$lint 2:$remote 3:$push]"

read number
while([[ $number != 1 ]] && [[ $number != 2 ]] && [[ $number != 3 ]]); do
    Yellow_Warning "Should enter 1 or 2 or 3"
    echo "请选择操作方式 ? [1:$lint 2:$remote 3:$push]"
    read number
done

# ==================== 打印参数 ==================== #

current_pod="LTResource"
current_git_tag=$(git tag -n --sort=-taggerdate | head -n 1)
current_version=$(echo $(grep -r "MARKETING_VERSION = " .) | awk -F ";" '{print $1}' | awk -F " = " '{print $2}')

Check_parameter true    "current_pod"
Check_parameter true    "current_git_tag"
Check_parameter true    "current_version"

# ==================== 具体操作 ==================== #

if [ $number == 1 ]; then
    current_work=$lint
    command="pod lib lint \
            --allow-warnings \
            --no-clean \
            --verbose"
    # LTResource passed validation.
    expect="${current_pod} passed validation."
    
elif [ $number == 2 ]; then
    current_work=$remote
    command="pod spec lint \
            --allow-warnings \
            --no-clean \
            --verbose"
    # LTResource.podspec passed validation.
    expect="${current_pod}.podspec passed validation."
    
elif [ $number == 3 ]; then
    current_work=$push
    command="pod repo push LetalkSpec LTResource.podspec \
            --allow-warnings"
    # - [Update] LTResource (0.0.2) Pushing the `LetalkSpec' repo
    expect="- [Update] ${current_pod} ($current_version) Pushing the \`LetalkSpec' repo"
fi

echo "--------------------开始${current_work}--------------------"

result=$(eval $command)

if [[ $result =~ $expect ]]; then
    Green_Success "${current_work}成功"
else
    echo $result
    Red_Error "${current_work}失败"
fi

exit 0
