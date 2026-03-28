helm repo list

helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo add brigade https://brigadecore.github.io/charts

helm repo remove bitnami

helm repo update
helm search repo mysql

https://artifacthub.io/
############################################################
helm search repo mysql
helm search repo database
helm search repo database --versions


############################################################
# search chart on  https://artifacthub.io/
helm search hub mysql
helm search hub mysql | wc -l

############################################################
#      Execute service using helm
############################################################
helm version
# https://artifacthub.io/



############################################################
#      Re Use Deployment Naming
############################################################
# create namespace
kubectl create namespace <namespace-name>
kubectl create namespace redis


helm install -n <namespace-name> <deployment-name> bitnami/redis --version 17.3.11
helm install -n redis my-redis bitnami/redis --version 17.3.11

helm list --all-namespaces
helm list -A

helm status <deployment-name>
helm status my-redis

helm delete <deployment-name>
helm delete my-redis
helm delete my-redis -n redis





############################################################
#      Provide Custom Values to HELM Chart
############################################################

helm list -A
kubectl create namespace <namespace-name>
kubectl create namespace my-mariadb


helm install -n <namespace-name> --values <file-name.yaml> <deployment-name> <repository-name> --version <version>
helm install -n database --values mariadb-custom.yaml my-mariadb oci://registry-1.docker.io/cloudpirates/mariadb --version 0.15.3


helm install -n database --values mariadb-custom.yaml my-mariadb bitnami/mariadb --version 25.0.6




helm install my-mariadb bitnami/mariadb \
  -n database \
  --values mariadb-custom.yaml \
  --set primary.persistence.enabled=false

kubectl get pods -n database
kubectl get storageclass

# get password:
kubectl get secret --namespace database my-mariadb -o jsonpath="{.data.mariadb-root-password}" | base64 -d

mysql -h my-mariadb.database.svc.cluster.local -uroot -p helm-db

# custom user:
mysql -h my-mariadb.database.svc.cluster.local -ucustom_usr -p helm-db



############################################################
#      Upgrade  Servce using Helm
############################################################
helm status my-redis -n <namespace-name>
helm status my-mariadb -n database


helm repo update

helm upgrade my-mariadb bitnami/mariadb \
  -n database \
  --version 25.0.5 \
  --values mariadb-custom.yaml \
  --set primary.persistence.enabled=false



############################################################
#      Helm Release Record
############################################################
kubectl get secret -n database
helm uninstall my-mariadb -n database --keep-history





#####################################################################################################
#####################################################################################################
#####################################################################################################
#################                SECTION 47 HELM Next Level                  ########################
#####################################################################################################
#####################################################################################################
#####################################################################################################


https://github.com/bitnami/charts/tree/main/bitnami/mariadb


helm list -A
kubectl create namespace <namespace-name>
kubectl create namespace my-mariadb

helm install my-mariadb bitnami/mariadb \
  -n database \
  --values mariadb-custom.yaml \
  --set primary.persistence.enabled=false \
  --dry-run


# for generating template
helm template my-mariadb bitnami/mariadb \
  -n database \
  --values mariadb-custom.yaml \
  --set primary.persistence.enabled=false 

kubectl get secrets -n database

############################################################
#      4. HELM Deployment releases
############################################################

helm upgrade my-mariadb bitnami/mariadb \
  -n database \
  --version 25.0.5 \
  --values mariadb-custom.yaml \
  --set primary.persistence.enabled=false

  # store secret in yaml
  kubectl get secrets -n database <secret> -O yaml 
  kubectl get secrets -n database sh.helm.release.v1.my-mariadb.v2 -o yaml

############################################################
#      5. Get details of deployed deployment
############################################################
# get release note of deployment
helm get notes my-mariadb -n database

# get values of deployment
helm get values my-mariadb -n database
helm get values my-mariadb -n database --revision 1

# get all values supplied to deployment
helm get manifest my-mariadb -n database
helm get manifest my-mariadb -n database --revision 1


############################################################
#      6. Rollback using HELM
############################################################
helm history my-mariadb -n database

helm rollback my-mariadb 1 -n database

kubectl get secret -n database
helm uninstall my-mariadb \
  -n database \
  --keep-history




############################################################
#      7. HELM Deployment
############################################################
# custom timeout for complete each step successfull installation / successful deployment
helm install my-mysql bitnami/mysql \
  --version 9.4.4 \
  --wait \
  --timeout 20m

helm upgrade my-mysql bitnami/mysql \
  --version 9.4.2 \
  --wait \
  --timeout 20m

kubectl get pods -n database

# if deployment failed rollback to previously successfull state
helm upgrade my-mysql bitnami/mysql \
  --version 9.4.2 \
  --set image.pullPolicy="AlwaysS" \
  --atomic

#######################
if failed rool back to previous successful  deploymnet

helm install my-mariadb bitnami/mariadb \
  -n database \
  --values mariadb-custom.yaml \
  --set primary.persistence.enabled=false


helm upgrade my-mariadb bitnami/mariadb \
  -n database \
  --version 25.0.5 \
  --values mariadb-custom.yaml \
  --set image.pullPolicy="AlwaysS" \
  --set primary.persistence.enabled=false \
  --atomic

helm history my-mariadb -n database

