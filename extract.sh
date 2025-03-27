name=$(cat ./build/info.json | jq -r '.name')
version=$(cat ./build/info.json | jq -r '.version')
out_name="${name}_${version}"
npx tstl
rm -rf ../${out_name}/
cp -r ./build/ ../${out_name}/
