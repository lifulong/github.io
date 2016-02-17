
echo "Generate and publish blog to master"
rm -rf tmp
cp -r _site tmp
cp README.md tmp/
cp LICENSE tmp/

cd tmp
git init
git add .
dt=`date +"%Y-%m-%d %H:%M:%S"`
message="Site updated at ${dt}"
git commit -m "${message}"
git remote add origin https://github.com/lifulong/lifulong.github.io.git
git push origin master --force
cd ..


