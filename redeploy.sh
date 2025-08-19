#!/bin/bash
set -e

APP=performace_tracker
MTAR=mta_archives/performace_tracker_1.0.0.mtar

echo "🔎 Aborting any stuck deployments..."
for i in $(cf dmol | grep $APP | awk '{print $2}'); do
  cf deploy -i $i -a abort || true
done

echo "🧹 Undeploying old MTA..."
cf undeploy $APP -f --delete-services || true

echo "🧹 Deleting leftover services..."
for svc in $(cf services | grep $APP | awk '{print $1}'); do
  cf delete-service $svc -f
done

echo "🚀 Deploying fresh MTAR..."
cf deploy $MTAR
