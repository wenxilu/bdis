#!/bin/bash
echo "====> create kube-scheduler csr"
cat > ${PKI_FILES_DIR}/kube-scheduler-csr.json <<EOF
{
    "CN": "system:kube-scheduler",
    "key": {
        "algo": "rsa",
        "size": 2048
    },
    "names": [
        {
            "C": "CN",
            "L": "CD",
            "ST": "SC",
            "OU": "System"
        }
    ]
}
EOF

echo "====> create kube-scheduler certificate"
cfssl gencert \
-ca=${PKI_FILES_DIR}/k8s-ca.pem \
-ca-key=${PKI_FILES_DIR}/k8s-ca-key.pem \
-config=${PKI_FILES_DIR}/k8s-ca-config.json \
-profile=kubernetes-ca-client \
${PKI_FILES_DIR}/kube-scheduler-csr.json | cfssljson -bare ${PKI_FILES_DIR}/kube-scheduler -
echo ""




echo "====> create kube-scheduler kubeconfig"
# kubeconfig kube-scheduler kubernetes default-scheduler kube-scheduler.kubeconfig kube-scheduler
CERT_NAME=kube-scheduler
CLUSTER_NAME=kubernetes
USER=default-scheduler
KUBECONFIG_NAME=kube-scheduler.kubeconfig
CONTEXT_NAME=kube-scheduler
MASTER_ADDR=https://127.0.0.1:6443
kubeconfig ${CERT_NAME} ${CLUSTER_NAME} ${USER} ${KUBECONFIG_NAME} ${CONTEXT_NAME} ${MASTER_ADDR}
echo ""
