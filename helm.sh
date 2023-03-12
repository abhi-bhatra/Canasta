#! /bin/bash

if ! command -v kubectl &> /dev/null
then
    echo "kubectl could not be found"
    exit
fi

if ! command -v helm &> /dev/null
then
    echo "helm could not be found"
    exit
fi

if ! kubectl cluster-info &> /dev/null
then
    echo "kubectl could not find a cluster"
    exit
fi

helm upgrade --install -f helm/values.yaml canasta ./helm
POD=$(sudo kubectl get pod -l app=canasta -o jsonpath="{.items[0].metadata.name}")
while ! sudo kubectl get pod -l app=canasta -o jsonpath="{.items[0].status.containerStatuses[0].ready}" | grep -q true; do
    echo "Waiting for canasta pod to be ready"
    sleep 5
done

if [ ! -f ./LocalSettings.php ]; then
    echo "LocalSettings.php not found"
    exit 0
else
    echo "LocalSettings.php found, copying to pod"

    sudo kubectl exec $POD -- rm /var/www/mediawiki/w/LocalSettings.php
    sudo kubectl cp ./LocalSettings.php $POD:/var/www/mediawiki/w
    ./init-cirrus-index.sh $POD

    echo "Installation Complete"
    exit 0
fi
