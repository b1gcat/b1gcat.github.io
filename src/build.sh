#npm install -g gitbook-cli
#npm install -g gitbook-summary
#npm install -g gitbook-plugin-simple-mind-map

gitbook install
book sm -i node_modules
gitbook build

rm -rf _book/build.sh
rm -rf _book/.gitignore
cp -rf _book/* ../../b1gcat.github.io/
rm -rf _book

