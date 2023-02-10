# 当前目录
cur_dir=$(dirname $(realpath $0))
#cur_dir="."
quality="20-30"

function show_usage() {
    local help=$(cat <<EOF

    png_quant.sh --directory <dir> 在指定目录搜索图片并按20-30的压缩比进行压缩

        -d|--directory <dir> - 指定查找目录，默认当前所在目录
        -q|--quality <固定值或范围区间> - 指定压缩质量
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
    -h|--help)
        show_usage
        exit 0
        ;;
    *)
        echo "Unknown option: $1"
        exit 1
    esac
done

find ${cur_dir} -name '*.png'
