# 当前目录
#cur_dir=$(dirname $(realpath $0))
cur_dir="."
quality=75
result_dir=""
is_replace=false

# 使用帮助
function show_usage() {
    local help=$(cat <<EOF

    to_webp.sh --directory <dir> 在指定目录搜索图片并按20-30的压缩比进行压缩

        -d|--directory <dir> - 指定查找目录，默认当前所在目录
        -q|--quality <Int> - 指定压缩质量（默认75）
        -r|--replace <Bool> - 是否直接进行替换
        --help  - prints help screen
EOF)
    echo "$help"
}

# 接受指定参数
while [[ $# -gt 0 ]]; do
    case "$1" in
    -d|--directory)
        shift
        cur_dir="$1"
        shift
        ;;
    -q|--quality)
        shift
        quality="$1"
        shift
        ;;
    -r|--replace)
        is_replace=true
        shift
        ;;
    -h|--help)
        show_usage
        exit 0
        ;;
    *)
        echo "Unknown option: $1"
        exit 1
    esac
done

Green_Success() {
    printf '\033[1;32;40m[success]%b\033[0m' "$1";
}

Yellow_Warnning() {
    printf '\033[1;33;40m[warnning]%b\033[0m' "$1";
}

Red_Error() {
    printf '\033[1;31;40m[error]%b\033[0m' "$1";
}

#修改分隔符为换行符（路径中可能包含空格）
old_IFS="$IFS"
IFS=$'\n'

# 创建文件夹
if ! $is_replace; then
    result_dir="$cur_dir/result"
    if [ ! -d "$result_dir" ];then
        mkdir $result_dir
    else
        for file in $result_dir/*; do
            rm -r $file
        done
    fi
fi

# 获取目录下所有图片资源
check_files=$(find -E "$cur_dir" -regex ".*\.(jpg|jpeg|png|webp|gif)")
# 遍历压缩
for img in $check_files; do
    # .imageset || .webp
    if [[ $img =~ ".imageset" || $img =~ ".webp" ]]; then
        continue
    fi

    # 图片名
    image_name=$(basename $img)
    # 图片名（不含后缀）
    image_no_suffix=$(echo $image_name | awk -F '.' '{print $1}')
    # 路径名
    folder_path="$result_dir/"
    if $is_replace; then
        folder_path=$(echo $img | awk -F $image_name '{print $1}')
    fi
    # 输出名
    out_name="$folder_path$image_no_suffix.webp"

    # .gif
    if [[ $image_name =~ "gif" ]]; then
        gif2webp -q $quality $img -o $out_name
    else
        cwebp -q $quality $img -o $out_name
    fi

    # 转换结果
    if [[ $? -ne 0 ]]; then
        Red_Error
        echo "${img}图片转换失败"
        continue
    fi

    # wc查看文件大小
    pic_size1=$(wc -c $img | awk '{print $1}')
    pic_size2=$(wc -c $out_name | awk '{print $1}')

    if [[ $pic_size2 -gt $pic_size1 ]]; then
        Red_Error
        echo "${img}图片转换后反而变大，放弃此次转换"
        rf $out_name
    fi
done

IFS="$old_IFS"

echo "执行完毕！！！"
exit 0
