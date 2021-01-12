# Type a script or drag a script file from your workspace to insert its path.

# 运行此脚本前
# podfile 必须加use_frameworks!
# 先编译一遍工程  确保正常运行 没有报错
# 方式一：作为sh文件运行  修改 my_lib_name
# 工程目录下创建framework.sh文件 全选粘贴此文本 命令行cd到工程目录下 运行命令sh framework.sh
# 工程目录下/Framework 生成合并后的framework文件

#脚本运行当前目录
cur_dir=$(cd "$(dirname "$0")"; pwd)
echo '*****当前项目目录----'$cur_dir'*****'


##定义库的名字  "TestFramework"
##默认动态获取，如果你设置了，就不动态获取了。
my_lib_name=""
#定义编译目录  当前工程的目录下
wrk_dir=$cur_dir'/Framework/build'
echo '*****build目录----'$wrk_dir'*****'

#定义编译目录  当前工程的目录下
framework_dir=$cur_dir'/Framework'
echo '*****framework目录----'$framework_dir'*****'

#删除已经存在的文件
if [ -d "${framework_dir}" ]
then
rm -rf "${framework_dir}"
fi

if [ "$my_lib_name"x == ""x ]
then
    path=$1
    files=$(ls $path)
    for filename in $files
    do
        if [[ $filename =~ ".xcodeproj" ]]
        then
             my_lib_name=${filename//.xcodeproj/}
             break
        fi
    done
fi

echo '*****库名----'$my_lib_name'*****'

echo '****************Pod Update Start*************'

sh pod_framework_mode.sh

is_frameworks=1 is_not_frameworks='_'$my_lib_name'_' pod update 

echo '****************Pod Update End*************'

#编译模式  ${CONFIGURATION}   Release   Debug
my_build_mode_array=("Release")

for my_build_mode in ${my_build_mode_array[@]}
do
    #源文件
    device_dir=${wrk_dir}/Build/Products/${my_build_mode}-iphoneos/${my_lib_name}/${my_lib_name}.framework
    simulator_dir=${wrk_dir}/Build/Products/${my_build_mode}-iphonesimulator/${my_lib_name}/${my_lib_name}.framework
    # 目标文件
    install_dir=${framework_dir}/${my_build_mode}/${my_lib_name}.framework

    echo '****************Build Start*************'
    xcodebuild build -workspace ${my_lib_name}.xcworkspace -scheme ${my_lib_name} -configuration ${my_build_mode} -sdk iphoneos clean build -derivedDataPath $wrk_dir
    xcodebuild build -workspace ${my_lib_name}.xcworkspace -scheme ${my_lib_name} -configuration ${my_build_mode} -sdk iphonesimulator -derivedDataPath $wrk_dir
    echo '****************Build End*************'

    echo '****************合并库架构 Start*************'
    #递归重建文件
    mkdir -p "${install_dir}"
    #拷贝文件  ${device_dir}/目录下的文件  拷贝到${install_dir}/目录下
    cp -R "${device_dir}/" "${install_dir}/"
    #合并库架构 同时支持模拟器和真机
    lipo -create "${device_dir}/${my_lib_name}" "${simulator_dir}/${my_lib_name}" -output "${install_dir}/${my_lib_name}"
    DATE=`date +%Y%m%d%H%M%S`
    #自增build时间版本
    new_build_number=$(($DATE))
    #设置build版本
    /usr/libexec/PlistBuddy -c "Set :CFBundleVersion $new_build_number" "${install_dir}/Info.plist"
    short_version=$(/usr/libexec/PlistBuddy -c "Print :CFBundleShortVersionString" "${install_dir}/Info.plist")
    short_version_DIR=${framework_dir}/${my_build_mode}/${short_version}.txt
    echo "currentVersion：$short_version">${short_version_DIR}

    echo '****************合并库架构 End*************'
done

rm -r "${wrk_dir}"



















