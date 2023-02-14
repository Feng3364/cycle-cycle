# 当前目录
#cur_dir=$(dirname $(realpath $0))
cur_dir="."
search_invalidate=false
declare -i threshold=10*1024

# 使用帮助
function show_usage() {
    local help=$(cat <<EOF

    find_unused_image.sh --directory <dir> 在指定目录查找Xcode未使用的图片

        -d|--directory <dir> - 指定查找目录，默认当前所在目录
        -i|--invalidate <Bool> - 是否查找1x图
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
    -i|--invalidate)
        search_invalidate=true
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
result_path="$cur_dir/result"
if [ ! -d "$result_path" ];then
    mkdir $result_path
else
    for file in $result_path/*; do
        rm $file
    done
fi

# 收集资源文件
image_sentence_file="$result_path/temp.txt"
unused_file="$result_path/unused.txt"
maybe_unused_file="$result_path/maybe.txt"
oversize_file="$result_path/oversize.txt"
contain1x_file="$result_path/contain1x.txt"

# 收集图片句柄(xib + OC + Swift + Swift便利方法)
echo $(grep -Er "image=\"|imageNamed\:|UIImage\(named\:|UIImageView\(with\:" $cur_dir) >> $image_sentence_file

# 获取目录下所有图片资源
check_files=$(find -E "$cur_dir" -regex ".*\.(jpg|jpeg|png|webp|gif)")
# 遍历压缩
for png in $check_files; do

    # bundle
    png_path=$png
    match_name=$(basename $png_path | awk -F '.png' '{print $1}')

    # .imageset
    if [[ $png =~ ".imageset" ]]; then
        png_path=$(echo $png | grep -Eo "/Users(.*).imageset")
        match_name=$(basename $png_path | awk -F '.imageset' '{print $1}')

        # 查询1x图
        if $search_invalidate; then
            # 换行分隔符+($变量)创建数组
            arr=(\$$(grep -r \"filename\" $png_path))
            if [[ ${#arr[@]} == 3 ]]; then
                echo $png_path >> $contain1x_file
            fi
        fi
    fi

    # 过大图片收集
    pic_size=`wc -c $png | awk '{print $1}'`
    if [[ $pic_size -gt $threshold ]]; then
        echo $png_path >> $oversize_file
    fi

    # 数字名图片收集
    containT=$(echo $match_name | grep "[0-9]")
    if [[ "$containT" != "" ]]; then
        echo $png_path >> $maybe_unused_file
    fi

    # 判断图片名称是否引用到
    if ! grep -q $match_name ${image_sentence_file}; then
        echo "${png_path} ${pic_size}KB" >> $unused_file
    fi

done

rm $image_sentence_file

IFS="$old_IFS"

echo "执行完毕！！！"
exit 0
