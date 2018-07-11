db.adminCommand('listDatabases');
db.mycol.insert({
    title: "test",
    val: "1230"
});
cursor = db.mycol.find();
while(cursor.hasNext())
{
    printjson(cursor.next());
}
