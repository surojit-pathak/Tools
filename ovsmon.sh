set -x

ovs-vsctl show

ovs-ofctl show br-int
ovs-ofctl show ovsbridge0
ovs-ofctl dump-flows br-int
ovs-ofctl dump-flows ovsbridge0

ovs-dpctl show
ovs-dpctl dump-flows system@br-int
ovs-dpctl dump-flows system@ovsbridge0
