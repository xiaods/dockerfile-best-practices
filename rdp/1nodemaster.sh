#!/bin/bash

exec voltdb create /opt/voltdb_data/genData/tpchPart.jar --deployment=/opt/voltdb_data/deploy1node.xml --host=localhost:3021 --zookeeper=2192
