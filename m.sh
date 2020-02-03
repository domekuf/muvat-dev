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

rpm()
{
    echo "$(git describe --dirty --always --match 'ver[0-9]*' --first-parent | sed -e 's|^ver||' -e 's|-|.|g')-0.x86_64"
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
	scp -i $TKEY $(pwd)/rpmbuild/RPMS/x86_64/cbrs-$(rpm).rpm $TEST:/var/cbrs/$(jit)
}

mpush-debuginfo()
{
	scp -i $TKEY $(pwd)/rpmbuild/RPMS/x86_64/cbrs-debuginfo-$(rpm).rpm $TEST:/var/cbrs/$(jit)
}

mins()
{
	ssh -i $TKEY $TEST "docker exec $(jit) yum install -y /var/cbrs/cbrs-$(rpm).rpm"
}

mreins()
{
	ssh -i $TKEY $TEST "docker exec $(jit) yum reinstall -y /var/cbrs/cbrs-$(rpm).rpm"
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

# Examples
# source m.sh && mrpm
# source m.sh && mpush-bin cbrs-daemon
# source m.sh && mpush-lib lib-cbrs
# source m.sh && mgdb src/cbrs-daemon/.libs/cbrs-daemon core.cbrs-daemon.1694.SPV-1396.1573551585
