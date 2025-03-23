name=$(cat ./build/info.json | jq '.name' | sed 's/^.\(.*\).$/\1/')
version=$(cat ./build/info.json | jq '.version' | sed 's/^.\(.*\).$/\1/')
out_name="${name}_${version}"
npx tstl
rm -rf ../${out_name}/
cp -r ./build/ ../${out_name}/
