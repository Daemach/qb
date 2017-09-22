component {

    this.title         = 'qb';
    this.author        = 'Eric Peterson';
    this.webURL        = 'https://github.com/elpete/qb';
    this.description   = 'Query builder for the rest of us';
    this.version       = '1.0.0';
    this.autoMapModels = false;
    this.cfmapping     = 'qb';

    function configure() {
        settings = {
            defaultGrammar = "BaseGrammar",
            returnFormat = "array"
        };

        interceptorSettings = {
            customInterceptionPoints = [ "preQBExecute", "postQBExecute" ]
        };

        binder.map( "BaseGrammar@qb" )
            .to( "qb.models.Query.Grammars.BaseGrammar" )
            .asSingleton();

        binder.map( "MySQLGrammar@qb" )
            .to( "qb.models.Query.Grammars.MySQLGrammar" )
            .asSingleton();

        binder.map( "OracleGrammar@qb" )
            .to( "qb.models.Query.Grammars.OracleGrammar" )
            .asSingleton();

        binder.map( "MSSQLGrammar@qb" )
            .to( "qb.models.Query.Grammars.MSSQLGrammar" )
            .asSingleton();

        binder.map( "QueryUtils@qb" )
            .to( "qb.models.Query.QueryUtils" )
            .asSingleton();
    }

    function onLoad() {
        binder.map( "DefaultGrammar@qb" )
            .to( "qb.models.Query.Grammars.#settings.defaultGrammar#" );

        binder.map( "builder@qb" )
            .to( "qb.models.Query.Builder" )
            .initArg( name = "grammar", ref = "DefaultGrammar@qb" )
            .initArg( name = "utils", ref = "QueryUtils@qb" )
            .initArg( name = "returnFormat", value = settings.returnFormat );
    }

}
