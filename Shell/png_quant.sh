# 当前目录
#cur_dir=$(dirname $(realpath $0))
cur_dir="."
quality="20-30"
zip_dir=""
cannot_zip_dir=""
is_replace=false

# 使用帮助
function show_usage() {
    local help=$(cat <<EOF

    png_quant.sh --directory <dir> 在指定目录搜索图片并按20-30的压缩比进行压缩

        -d|--directory <dir> - 指定查找目录，默认当前所在目录
        -q|--quality <固定值或范围区间> - 指定压缩质量
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

#修改分隔符为换行符（路径中可能包含空格）
old_IFS="$IFS"
IFS=$'\n'

# 创建文件夹
if ! $is_replace; then
    zip_dir="$cur_dir/zip_dir"
    if [ ! -d "$zip_dir" ];then
        mkdir $zip_dir
    else
        for file in $zip_dir/*; do
            rm $file
        done
    fi
fi

cannot_zip_dir="$cur_dir/cannot_zip_dir"
if [ ! -d "$cannot_zip_dir" ];then
    mkdir $cannot_zip_dir
else
    for file in $cannot_zip_dir/*; do
        rm $file
    done
fi

# 获取目录下所有图片资源
check_files=$(find "$cur_dir" -name '*.png')
# 遍历压缩
for png in $check_files; do
    # .imageset
    if [[ $png =~ ".imageset" ]]; then
        continue
    fi
    
    pngquant --quality=$quality $png

    if [[ $? -ne 0 ]]; then
        echo "原图${png}压缩失败"
        cp $png $cannot_zip_dir
        continue
    fi

    # 拼接压缩后的图片名称(awk分隔字符串)
    pre_name=$(echo $png | awk -F '.png' '{print $1}')
    pre_name="${pre_name}-fs8.png"

    # wc查看文件大小
    pic_size1=$(wc -c $png | awk '{print $1}')
    pic_size2=$(wc -c $pre_name | awk '{print $1}')

    if [[ $pic_size2 -lt $pic_size1 ]]; then
        if $is_replace; then
            mv $pre_name $png
        else
            mv $pre_name $zip_dir
        fi
    else
        echo "原图${png}"
        echo "压缩图$pre_name"
        echo "压缩后图片大小反而变大，放弃此次压缩"
        mv $pre_name $cannot_zip_dir
    fi

done

IFS="$old_IFS"

echo "执行完毕！！！"
exit 0
