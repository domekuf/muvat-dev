IMAGE=dev.jmawireless.com/jenkins-docker/jenkins-cbrs
ID=jenkins$(pwd | sed "s@$HOME@@g" | sed "s@/@-@g")
TEST=centos@10.150.4.222
TKEY=$HOME/.ssh/cbrs-sas-openstack
TWRK=/home/centos/cbrs-docker

board()
{

    git branch | grep '*' | sed 's/.*\///' | sed 's/\(.*\)-[0-9]*-.*/\1/'
}

number()
{
    git branch | grep '*' | sed 's/.*\///' | sed 's/.*-\([0-9]*\)-.*/\1/'
}

jit()
{
    echo "$(board)-$(number)"

}

rpm-name()
{
    echo "$(git describe --dirty --always --match 'ver[0-9]*' --first-parent | sed -e 's|^ver||' -e 's|-|.|g')-1.el7.x86_64"
}

new-jnk()
{
    docker run --privileged --detach --volume /etc/localtime:/etc/localtime:ro \
        --mount type=volume,dst=/home/jenkins/workspace,volume-driver=local,volume-opt=type=none,volume-opt=o=bind,volume-opt=device=$(pwd) \
        --hostname $ID --name $ID $IMAGE /sbin/init
}

new-cnt()
{
    ssh -i $TKEY $TEST "cd $TWRK && make run-ext PORT=$(number)"
}

mpush-rpm()
{
	scp -i $TKEY $(pwd)/rpmbuild/RPMS/x86_64/cbrs-$(rpm-name).rpm $TEST:/var/cbrs/$(jit)
}

mpush-debuginfo()
{
	scp -i $TKEY $(pwd)/rpmbuild/RPMS/x86_64/cbrs-debuginfo-$(rpm-name).rpm $TEST:/var/cbrs/$(jit)
}

mins()
{
	ssh -i $TKEY $TEST "docker exec $(jit) yum install -y /var/cbrs/cbrs-$(rpm-name).rpm"
}

mreins()
{
	ssh -i $TKEY $TEST "docker exec $(jit) yum reinstall -y /var/cbrs/cbrs-$(rpm-name).rpm"
}

mrpm()
{
    docker exec $ID git submodule update --init --progress
    docker exec $ID sh ./jenkins.sh
}

mmake()
{
    docker exec $ID sh ./pre-jenkins.sh $@
}

mpush-bin()
{
    scp -i $TKEY $(pwd)/src/$1/.libs/$1 $TEST:/tmp/$(jit)-$1
    ssh -i $TKEY $TEST "docker exec $(jit) pkill $1"
    ssh -i $TKEY $TEST "docker cp /tmp/$(jit)-$1 $(jit):/usr/bin/$1"
}

mpush-bin-dbg-cbrs()
{
    scp -i $TKEY $(pwd)/src/cbrs-daemon/.libs/dbg-cbrs $TEST:/tmp/$(jit)-dbg-cbrs
    ssh -i $TKEY $TEST "docker exec $(jit) pkill dbg-cbrs"
    ssh -i $TKEY $TEST "docker cp /tmp/$(jit)-dbg-cbrs $(jit):/usr/bin/dbg-cbrs"
}

mpush-lib()
{
    scp -i $TKEY $(pwd)/src/$1/.libs/*.so.1 $TEST:/tmp/
    ssh -i $TKEY $TEST "docker cp /tmp/*.so.1 $(jit):/usr/lib64/cbrs/"
    ssh -i $TKEY $TEST "rm /tmp/*.so.1"
}

mpush-var()
{
    scp -i $TKEY $1 $TEST:/tmp/
    ssh -i $TKEY $TEST "docker cp /tmp/$1 $(jit):/var/cbrs/"
    ssh -i $TKEY $TEST "rm /tmp/$1"
}

mpush-etc()
{
    scp -i $TKEY $1 $TEST:/tmp/
    ssh -i $TKEY $TEST "docker cp /tmp/$1 $(jit):/etc/cbrs/"
    ssh -i $TKEY $TEST "rm /tmp/$1"
}

mpull-core()
{
    ssh -i $TKEY $TEST "sudo chmod 666 /var/cbrs/$(jit)/core*"
    scp -i $TKEY $TEST:/var/cbrs/$(jit)/core* .
}

mpull-var()
{
    scp -i $TKEY $TEST:/var/cbrs/$(jit)/$1 .
}

mgdb()
{
    docker exec -it $ID gdb $@
}

attach()
{
    docker exec -it $ID /bin/bash
}

go-test()
{
    ssh -i $TKEY $TEST
}

doc-to-test()
{
    scp -i $TKEY doc/cbrs-api.yaml $TEST:/var/express/cbrs-api/
    ssh -i $TKEY $TEST "docker restart cbrs-api"
}

mauto()
{
    ssh -i $TKEY $TEST "docker exec $(jit) touch /etc/cbrs/0.pem"
    ssh -i $TKEY $TEST "docker exec $(jit) chown xran:xran /etc/cbrs/0.pem"
    ssh -i $TKEY $TEST "docker exec $(jit) chmod 0400 /etc/cbrs/0.pem"
    ssh -i $TKEY $TEST "docker exec $(jit) sed -i 's%clientCert\"[^,]*%clientCert\": \"/etc/cbrs/0.pem\"'%g /var/cbrs/cbrs.json"
}

class-name()
{
    echo $1 | sed 's@.*/\([a-Z\]\+\)[\.chp]*@\1@g'
}

class-path()
{
    echo $1 | sed 's@\(.*/\)[a-Z\.]\+@\1@g'
}

h-guard()
{
    h_guard=$(echo $1 | sed 's@\([a-z]\)\([A-Z]\)@\1_\2@g')
    h_guard=$(echo $h_guard | sed 's@\([a-Z]\+\)[^a-Z]*@\U\1_@g')
    h_guard=$h_guard"HPP_"
    echo $h_guard
}

class-cp()
{
    old_name=$(class-name $1)
    new_name=$(class-name $2)
    old_path=$(class-path $1)
    new_path=$(class-path $2)
    old_class=$old_path$old_name
    new_class=$new_path$new_name
    old_h_guard=$(h-guard $1)
    new_h_guard=$(h-guard $2)
    if [[ $old_path == $new_path ]]; then
        makefile="$new_path""Makefile.am"
        echo "Attempting to update $makefile"
        sed -i "s/$old_name/$new_name/g" $makefile
    else
        echo "Please manually update $new_path""Makefile.am"
    fi
    #echo $old_name $new_name $old_path $new_path $old_class $new_class $old_h_guard $new_h_guard $makefile
    cp $old_class.hpp $new_class.hpp
    cp $old_class.cpp $new_class.cpp
    sed -i "s/$old_name/$new_name/g" $new_class.cpp
    sed -i "s/$old_name/$new_name/g" $new_class.hpp
    sed -i "s/$old_h_guard/$new_h_guard/g" $new_class.hpp
    echo "Now, if you feel safe, you can remove $old_class.{h,c}pp"
}

class-touch()
{

    name=$(class-name $1)
    path=$(class-path $1)
    class=$path$name
    h_guard=$(h-guard $1)
    touch $class.{h,c}pp
    name=$(echo $class | sed 's@.*/\([a-Z]\+\)@\1@g')
    h_guard=$(echo $1 | sed 's@\([a-Z]\+\)[^a-Z]*@\U\1_@g')
    h_guard=$h_guard"HPP_"
    echo "#ifndef $h_guard"     >> $class.hpp
    echo "#define $h_guard"     >> $class.hpp
    echo "namespace spv {"      >> $class.hpp
    echo "namespace cbrs {"     >> $class.hpp
    echo ""                     >> $class.hpp
    echo "class $name"          >> $class.hpp
    echo "{"                    >> $class.hpp
    echo "};"                   >> $class.hpp
    echo ""                     >> $class.hpp
    echo "} // namespace cbrs"  >> $class.hpp
    echo "} // namespace spv"   >> $class.hpp
    echo "#endif // $h_guard"   >> $class.hpp
    echo "#include \"$name.hpp\""       >> $class.cpp
    echo "namespace spv {"              >> $class.cpp
    echo "namespace cbrs {"             >> $class.cpp
    echo ""                             >> $class.cpp
    echo "$name::$name()"               >> $class.cpp
    echo "{"                            >> $class.cpp
    echo "}"                            >> $class.cpp
    echo ""                             >> $class.cpp
    echo "} // namespace cbrs"          >> $class.cpp
    echo "} // namespace spv"           >> $class.cpp
    echo "Please add $name to Makefile and git"
}

# Examples
# source m.sh && mrpm
# source m.sh && mpush-bin cbrs-daemon
# source m.sh && mpush-lib lib-cbrs
# source m.sh && mgdb src/cbrs-daemon/.libs/cbrs-daemon core.cbrs-daemon.1694.SPV-1396.1573551585
