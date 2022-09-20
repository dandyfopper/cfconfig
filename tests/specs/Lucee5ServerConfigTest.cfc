/**
*********************************************************************************
* Copyright Since 2017 CommandBox by Ortus Solutions, Corp
* www.ortussolutions.com
********************************************************************************
* @author Brad Wood
*/
component extends="tests.BaseTest" appMapping="/tests" {



	function run(){

		describe( "Lucee 5 Server config", function(){

			it( "can read config", function() {

				var Lucee5ServerConfig = getInstance( 'Lucee5Server@cfconfig-services' )
					.read( expandPath( '/tests/resources/lucee5/ServerHome/Lucee-Server' ) );

				expect( Lucee5ServerConfig.getMemento() ).toBeStruct();
			});

			it( "can write config", function() {

				var Lucee5ServerConfig = getInstance( 'Lucee5Server@cfconfig-services' )
					.read( expandPath( '/tests/resources/lucee5/ServerHome/Lucee-Server' ) )
					.write( expandPath( '/tests/resources/tmp' ) );

				expect( fileExists( '/tests/resources/tmp/context/Lucee-Server.xml' ) ).toBeTrue();
				expect( isXML( fileRead( '/tests/resources/tmp/context/Lucee-Server.xml' ) ) ).toBeTrue();
			});

		});

        describe( "Lucee 5 Server config - Datasource settings", function(){

            beforeEach(function(currentSpec, data){

				if( directoryExists( expandPath( '/tests/resources/tmp' )) ){
					DirectoryDelete( expandPath( '/tests/resources/tmp' ), true );
				}
			});

			it( "can read datasource configs with liveTimeout (CFCONFIG-55)", function() {

				var Lucee5ServerConfig = getInstance( 'Lucee5Server@cfconfig-services' )
					.read( expandPath( '/tests/resources/lucee5/serverHome/lucee-server' ) );

				expect( Lucee5ServerConfig.getMemento() ).toBeStruct();

                var config = Lucee5ServerConfig.getMemento();
				expect( config ).toHaveKey( "datasources" );
				expect( config.datasources ).toBeTypeOf( "struct" );
				expect( config.datasources ).toHaveKey( "mydatabaseWithLiveTimeout" );

                var datasourceUnderTest = config.datasources.mydatabaseWithLiveTimeout;
                expect( datasourceUnderTest ).toHaveKey( "liveTimeout" );
                expect( datasourceUnderTest.liveTimeout ).toBe( 30 );
			});

            it( "can write datasource configs with liveTimeout (CFCONFIG-55)", function() {

				var Lucee5ServerConfig = getInstance( 'Lucee5Server@cfconfig-services' )
					.read( expandPath( '/tests/resources/lucee5/serverHome/lucee-server' ) );

					expect( Lucee5ServerConfig.getMemento() ).toHaveKey( "datasources" );

					// Write it back out.
					Lucee5ServerConfig.write( expandPath( '/tests/resources/tmp' ) );

				expect( fileExists( '/tests/resources/tmp/context/lucee-server.xml' ) ).toBeTrue();
				expect( isXML( fileRead( '/tests/resources/tmp/context/lucee-server.xml' ) ) ).toBeTrue();

				var config = XMLParse( fileRead( '/tests/resources/tmp/context/lucee-server.xml' ) );
		        var datasourceUnderTest = xmlSearch( config, "cfLuceeConfiguration//data-sources//data-source[@name='mydatabaseWithLiveTimeout']" )[1];
                expect( datasourceUnderTest.XMLAttributes ).toHaveKey( "liveTimeout" );
                expect( datasourceUnderTest.XMLAttributes.liveTimeout ).toBe( 30 );
            });

		});

		describe( "Lucee 5 Server config - ComponentPaths", function(){

			beforeEach(function(currentSpec, data){

				if( directoryExists( expandPath( '/tests/resources/tmp' )) ){
					DirectoryDelete( expandPath( '/tests/resources/tmp' ), true );
				}
			});

			it( "can read ComponentPaths config", function() {

				var Lucee5ServerConfig = getInstance( 'Lucee5Server@cfconfig-services' )
					.read( expandPath( '/tests/resources/lucee5/ServerHome/Lucee-Server' ) );

				expect( Lucee5ServerConfig.getMemento() ).toBeStruct();

				var config = Lucee5ServerConfig.getMemento();
				debug(config);

				expect( config ).toHaveKey( "componentPaths" );
				expect( config.componentPaths ).toBeTypeOf( "struct" );

				expect( config.componentPaths ).toHaveKey( "exampleComponentPath" );

				var exampleComponent = config.componentPaths.exampleComponentPath;

				debug(exampleComponent)
				expect( exampleComponent ).toHaveKey( "name" );
				expect( exampleComponent ).toHaveKey( "physical" );
				// expect( exampleComponent ).toHaveKey( "archive" );
				expect( exampleComponent ).toHaveKey( "primary" );
				expect( exampleComponent ).toHaveKey( "inspectTemplate" );
				expect( exampleComponent ).NotToHaveKey( "readonly" );

			});

			it( "can write ComponentPaths config", function() {

				var Lucee5ServerConfig = getInstance( 'Lucee5Server@cfconfig-services' )
					.read( expandPath( '/tests/resources/lucee5/ServerHome/Lucee-Server' ) );

					expect( Lucee5ServerConfig.getMemento()  ).toHaveKey("componentPaths");
					debug( Lucee5ServerConfig.getMemento() );

					// Write it back out.
					Lucee5ServerConfig.write(  expandPath( '/tests/resources/tmp' ) );

				expect( fileExists( '/tests/resources/tmp/context/Lucee-Server.xml' ) ).toBeTrue();
				expect( isXML( fileRead( '/tests/resources/tmp/context/Lucee-Server.xml' ) ) ).toBeTrue();

				var config = XMLParse( fileRead( '/tests/resources/tmp/context/Lucee-Server.xml' ) );
				debug( config.XmlRoot.component );

				// This is kinda incorrect, but it's from the xml that goes in.
				expect( config.XmlRoot.component.XMLChildren.len() ).toBe( 3 );

			});

		});

	}

}
