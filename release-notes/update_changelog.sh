[[ -e kubevirt ]] || git clone --depth=1 git@github.com:kubevirt/kubevirt.git
git -C kubevirt checkout master
git -C kubevirt pull

releases() {
git -C kubevirt tag | sort -rV | while read TAG ;
do
  [[ "$TAG" =~ [0-9].0$ ]] || continue ;
  echo "$TAG" ;
done
}

features_for() {
  echo -e  ""
  git -C kubevirt show $1 | grep Date: | head -n1 | sed "s/Date:\s\+/Released on: /"
  echo -e  ""
  git -C kubevirt show $1 | sed -n "/changes$/,/Contributors/ p" | egrep "^- " ;
}

gen_changelog() {
  {
  echo "# Changelog"
  for REL in $(releases);
  do
    echo -e "\n## $REL" ;
    features_for $REL
  done
  } > changelog.adoc
}

gen_changelog
