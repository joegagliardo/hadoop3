/*
pig -useHCatalog
*/
x = load 'regions' USING org.apache.hive.hcatalog.pig.HCatLoader();
describe x;
dump x;
