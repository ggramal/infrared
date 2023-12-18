#!/bin/bash
# check availability rfr-redis pod
if [[ -z $* ]]; then
	local_port=6379
else
	local_port=$1
fi
echo "Using your $local_port port"
if echo $(kubectl get pods -A) | grep -q "rfr-"; then
	# get namespace
	namespace=$(kubectl get pods -A | awk '/rfr-/{print $1}' | head -1)
	# get list of rfr-redis pod names
	rfr_redis_pods=($(kubectl get pods -n $namespace | awk '/rfr-/{print $1}'))
	# search master rfr-redis pod
	for pod in "${rfr_redis_pods[@]}"; do
		if kubectl describe pod $pod -n $namespace | grep -q "redisfailovers-role=master"; then
	               master_redis_rfr_pod=$pod
		       # get redis port
	               redis_port=$(kubectl describe pod $pod -n $namespace | awk '/REDIS_PORT/{print $2}' | head -1)
		fi
	done
	# get password
	if [[ $namespace == "redis" ]]; then
		redis_pas=$(kubectl get secret -n $namespace redis-main -o jsonpath="{.data.password}" | base64 -d)
	else
		redis_pas=$(kubectl get secret -n $namespace tf-generic-secret-redis -o jsonpath="{.data.password}" | base64 -d)
	fi
	echo "Redis password: $redis_pas"
	# use kubectl port-forward
	kubectl port-forward pod/$master_redis_rfr_pod -n $namespace $local_port:$redis_port # --address='0.0.0.0'
fi

