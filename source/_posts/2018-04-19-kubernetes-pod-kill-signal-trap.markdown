
---
title : "kubernetes pod kill signal trap"
layout: post
category : bash
tagline: ""
tags : [Kubernetes, Signal, Nginx, Trap]
---


### 问题描述



### 捕获kill信号失败



### 临时解决

临时解决方案是，每个pod里面只启动一个进程，一个服务。

### 捕获kill信号试验

试验测试kubernete杀掉docker进程的信号


#### 试验kill信号docker启动脚本

```
#!/bin/bash

_term1() { 
	echo "Caught SIGTERM signal!" 
	exit 0
}
_term2() { 
	echo "Caught SIGUSR1 signal!" 
	exit 0
}
_term3() { 
	echo "Caught TERM signal!" 
	exit 0
}
_term4() {
	echo "Caught INT signal!" 
	exit 0
}

trap _term1 SIGTERM
trap _term2 SIGUSR1
trap _term3 TERM
trap _term4 INT

echo "Start nginx"

while [ 1 -eq 1 ];do
	sleep 1
	echo "OK"
done
```

#### kubernetes试验create deploy配置文件

```
apiVersion: extensions/v1beta1
kind: Deployment
metadata:
  name: test-kill
  namespace: default
spec:
  replicas: 1
  template:
    metadata:
      labels:
        app: test-jupyter
    spec:
      nodeName: m7-pce-gpu01
      containers:
      - name: tf1
        image: docker02:35000/notebook-test:test
        resources:
          limits:
            alpha.kubernetes.io/nvidia-gpu: 0
            memory: 1096M
            cpu: 100m
          requests:
            alpha.kubernetes.io/nvidia-gpu: 0
            memory: 1096M
            cpu: 100m
```

#### kubernetes命令

```
kubectl create -f deploy.yaml 
kubectl delete deploy 
```

#### 最终docker启动脚本:

```
#!/bin/bash

_term3() { 
	echo "Caught TERM signal!" 
	ps aux | grep nginx | grep -v grep | awk '{print $2;}' | xargs kill -9
	echo "Kill nginx!"
	exit 0
}

trap _term3 TERM

nginx

echo "Start nginx"

while [ 1 -eq 1 ];do
	sleep 1
	echo "OK"
done
```

