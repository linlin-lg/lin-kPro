#!/bin/sh
# 使用SwiftCLI生成环境文件
rm -rf .build
swift build -c release --product appconfigfetcher
mv .build/release/appconfigfetcher ../appconfigfetcher
rm -rf .build
