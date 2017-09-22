component extends="testbox.system.BaseSpec" {

    function run() {
        describe( "schema builder + oracle grammar", function() {
            describe( "column types", function() {
                it( "enum", function() {
                    var schema = getBuilder();
                    var blueprint = schema.create( "employees", function( table ) {
                        table.enum( "tshirt_size", [ "S", "M", "L", "XL", "XXL" ] );
                    }, {}, false );
                    var statements = blueprint.toSql();
                    expect( statements ).toBeArray();
                    expect( statements ).toHaveLength( 1 );
                    expect( statements[ 1 ] ).toBeWithCase( "CREATE TABLE ""EMPLOYEES"" (""TSHIRT_SIZE"" VARCHAR(255) CHECK(""TSHIRT_SIZE"" IN (""S"",""M"",""L"",""XL"",""XXL"")) NOT NULL)" );
                } );
            } );

            describe( "rename columns", function() {
                it( "renames a column", function() {
                    var schema = getBuilder();
                    var blueprint = schema.alter( "users", function( table ) {
                        table.renameColumn( "name", table.string( "username" ) );
                    }, {}, false );
                    var statements = blueprint.toSql();
                    expect( statements ).toBeArray();
                    expect( statements ).toHaveLength( 1 );
                    expect( statements[ 1 ] ).toBeWithCase( "ALTER TABLE ""USERS"" RENAME COLUMN ""NAME"" TO ""USERNAME""" );
                } );

                it( "renames multiple columns", function() {
                    var schema = getBuilder();
                    var blueprint = schema.alter( "users", function( table ) {
                        table.renameColumn( "name", table.string( "username" ) );
                        table.renameColumn( "purchase_date", table.timestamp( "purchased_at" ).nullable() );
                    }, {}, false );
                    var statements = blueprint.toSql();
                    expect( statements ).toBeArray();
                    expect( statements ).toHaveLength( 2 );
                    expect( statements[ 1 ] ).toBeWithCase( "ALTER TABLE ""USERS"" RENAME COLUMN ""NAME"" TO ""USERNAME""" );
                    expect( statements[ 2 ] ).toBeWithCase( "ALTER TABLE ""USERS"" RENAME COLUMN ""PURCHASE_DATE"" TO ""PURCHASED_AT""" );
                } );
            } );

            describe( "modify columns", function() {
                it( "modifies a column", function() {
                    var schema = getBuilder();
                    var blueprint = schema.alter( "users", function( table ) {
                        table.modifyColumn( "name", table.string( "name", 100 ) );
                    }, {}, false );
                    var statements = blueprint.toSql();
                    expect( statements ).toBeArray();
                    expect( statements ).toHaveLength( 1 );
                    expect( statements[ 1 ] ).toBeWithCase( "ALTER TABLE ""USERS"" MODIFY ""NAME"" VARCHAR(100) NOT NULL" );
                } );

                it( "modifies multiple columns", function() {
                    var schema = getBuilder();
                    var blueprint = schema.alter( "users", function( table ) {
                        table.modifyColumn( "name", table.string( "name", 100 ) );
                        table.modifyColumn( "purchase_date", table.timestamp( "purchase_date" ).nullable() );
                    }, {}, false );
                    var statements = blueprint.toSql();
                    expect( statements ).toBeArray();
                    expect( statements ).toHaveLength( 2 );
                    expect( statements[ 1 ] ).toBeWithCase( "ALTER TABLE ""USERS"" MODIFY ""NAME"" VARCHAR(100) NOT NULL" );
                    expect( statements[ 2 ] ).toBeWithCase( "ALTER TABLE ""USERS"" MODIFY ""PURCHASE_DATE"" TIMESTAMP" );
                } );
            } );

            describe( "adding columns", function() {
                it( "can add a new column", function() {
                    var schema = getBuilder();
                    var blueprint = schema.alter( "users", function( table ) {
                        table.addColumn( table.enum( "tshirt_size", [ "S", "M", "L", "XL", "XXL" ] ) );
                    }, {}, false );
                    var statements = blueprint.toSql();
                    expect( statements ).toBeArray();
                    expect( statements ).toHaveLength( 1 );
                    expect( statements[ 1 ] ).toBeWithCase( "ALTER TABLE ""USERS"" ADD ""TSHIRT_SIZE"" VARCHAR(255) CHECK(""TSHIRT_SIZE"" IN (""S"",""M"",""L"",""XL"",""XXL"")) NOT NULL" );
                } );

                it( "can add multiple columns", function() {
                    var schema = getBuilder();
                    var blueprint = schema.alter( "users", function( table ) {
                        table.addColumn( table.enum( "tshirt_size", [ "S", "M", "L", "XL", "XXL" ] ) );
                        table.addColumn( table.boolean( "is_active" ) );
                    }, {}, false );
                    var statements = blueprint.toSql();
                    expect( statements ).toBeArray();
                    expect( statements ).toHaveLength( 2 );
                    expect( statements[ 1 ] ).toBeWithCase( "ALTER TABLE ""USERS"" ADD ""TSHIRT_SIZE"" VARCHAR(255) CHECK(""TSHIRT_SIZE"" IN (""S"",""M"",""L"",""XL"",""XXL"")) NOT NULL" );
                    expect( statements[ 2 ] ).toBeWithCase( "ALTER TABLE ""USERS"" ADD ""IS_ACTIVE"" TINYINT(1) NOT NULL" );
                } );
            } );

            xit( "can drop and add and rename and modify columns at the same time", function() {
                var schema = getBuilder();
                var blueprint = schema.alter( "users", function( table ) {
                    table.dropColumn( "is_active" );
                    table.addColumn( table.enum( "tshirt_size", [ "S", "M", "L", "XL", "XXL" ] ) );
                    table.renameColumn( "name", table.string( "username" ) );
                    table.modifyColumn( "purchase_date", table.timestamp( "purchase_date" ).nullable() );
                }, {}, false );
                var statements = blueprint.toSql();
                expect( statements ).toBeArray();
                expect( statements ).toHaveLength( 4 );
                expect( statements[ 1 ] ).toBeWithCase( "ALTER TABLE ""users"" DROP COLUMN ""is_active""" );
                expect( statements[ 2 ] ).toBeWithCase( "ALTER TABLE ""USERS"" ADD ""TSHIRT_SIZE"" VARCHAR(255) CHECK(""TSHIRT_SIZE"" IN (""S"",""M"",""L"",""XL"",""XXL"")) NOT NULL" );
                expect( statements[ 3 ] ).toBeWithCase( "ALTER TABLE ""users"" RENAME COLUMN ""name"" TO ""username""" );
                expect( statements[ 4 ] ).toBeWithCase( "ALTER TABLE ""users"" MODIFY ""purchase_date"" TIMESTAMP" );
            } );
        } );
    }

    private function getBuilder() {
        var utils = getMockBox().createMock( "qb.models.Query.QueryUtils" );
        var grammar = getMockBox()
            .createMock( "qb.models.Grammars.OracleGrammar" )
            .init( utils );
        var builder = getMockBox().createMock( "qb.models.Schema.SchemaBuilder" )
            .init( grammar );
        return builder;
    }

}
