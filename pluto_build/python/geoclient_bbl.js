/////////////////////////////////////////////////////////////////////////////////////////////////////////
// PROCESS OVERVIEW
/////////////////////////////////////////////////////////////////////////////////////////////////////////

// Select all records with null geoms and a boro value
// Geocode using boro and address -- prints errors and and skips to keep going
// Reject records do not get updated in the database.

/////////////////////////////////////////////////////////////////////////////////////////////////////////
// STEP 1 --- LOADING DEPENDENCIES
/////////////////////////////////////////////////////////////////////////////////////////////////////////


// REQUIRE CODE LIBRARY DEPENDENCIES
var pgp = require('pg-promise')(), 
  request = require('request'),
  Mustache = require('mustache');

// REQUIRE JS FILE WITH API CREDENTIALS -- USED IN addressLookup FUNCTION
// ALSO REQUIRES WITH DATABASE CONFIGURATION
var config = require('../../plutoconfig.js');

// USE DATABASE CONFIGURATION JS FILE TO LINK TO DATABASE
var db = pgp(config);


/////////////////////////////////////////////////////////////////////////////////////////////////////////
// STEP 2 --- DEFINING THE QUERY USED TO FIND NULL GEOMETRIES
/////////////////////////////////////////////////////////////////////////////////////////////////////////


// querying for records without geoms
var nullGeomQuery = `SELECT DISTINCT
                      boro,
                      addressnum,
                      streetname
                    FROM pluto_rpad_geo
                    WHERE
                      borough IS NOT NULL
                      AND tb IS NOT NULL
                      AND tl IS NOT NULL
                      AND geom IS NULL`;


/////////////////////////////////////////////////////////////////////////////////////////////////////////
// STEP 3 --- APPLYING THE nullGeomQuery IN THE DATABASE TO FIND RECORDS WITH NULL GEOM
/////////////////////////////////////////////////////////////////////////////////////////////////////////


var i=0;
var nullGeomResults;

db.any(nullGeomQuery)
  .then(function (data) { 
    nullGeomResults = data

    console.log('Found ' + nullGeomResults.length + ' null geometries in pluto rpad ')
    addressLookup1(nullGeomResults[i]);
  })
  .catch(function(err) {
    console.log(err)
  })


/////////////////////////////////////////////////////////////////////////////////////////////////////////
// STEP 4 --- SETTING TEMPLATES FOR REQUEST TO API -- REQUIRES ADDRESS#, STREET NAME, AND BORO OR ZIP
/////////////////////////////////////////////////////////////////////////////////////////////////////////


// records without geoms and with boro
var geoclientTemplate1 = 'https://api.cityofnewyork.us/geoclient/v1/bbl.json?borough={{borough}}&block={{tb}}&lot={{tl}}&app_id={{app_id}}&app_key={{app_key}}';


/////////////////////////////////////////////////////////////////////////////////////////////////////////
// STEP 5 --- DEFINES AND RUNS FUNCTION WHICH LOOKS UP ADDRESSES USING geoclientTemplate
/////////////////////////////////////////////////////////////////////////////////////////////////////////


function addressLookup1(row) {
      var apiCall1 = Mustache.render(geoclientTemplate1, {
        
        // MAKE SURE THESE MATCH THE FIELD NAMES
        borough: row.borough,
        tb: row.tb,
        tl: row.tl,
        app_id: config.app_id,
        app_key: config.app_key
      })

      // console.log(apiCall1);

      request(apiCall1, function(err, response, body) {
          console.log(err)
          // A. try PARSING json
          try { 
            var data = JSON.parse(body)
            // B. try getting ADDRESS from data response
            try {
              data = data.address;
              // C. try UPDATING facilities with the address from data
              try {
                updateFacilities(data, row)
              // C. catch error when UPDATING facilities table
              } catch (e) {
                console.log(data)
                i++;
                // console.log(i,nullGeomResults.length)
                  if (i<nullGeomResults.length) {
                    addressLookup1(nullGeomResults[i])
                  }
              }
            // B. catch error with getting ADDRESS from data response
            } catch (e) {
              i++;
              // console.log(i,nullGeomResults.length)
              if (i<nullGeomResults.length) {
                addressLookup1(nullGeomResults[i])
              }
            }
          // A. catch error with PARSING json
          } catch (e) {
            i++;
            // console.log(i,nullGeomResults.length)
            if (i<nullGeomResults.length) {
              addressLookup1(nullGeomResults[i])
            }
          }
      })
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////
// STEP 6 --- DEFINES/RUNS FUNCTION updateFacilities 
/////////////////////////////////////////////////////////////////////////////////////////////////////////


function updateFacilities(data, row) {

  var insertTemplate = `UPDATE pluto_rpad_geo 
                        SET
                          geom=(CASE
                            WHEN geom IS NULL THEN ST_SetSRID(ST_GeomFromText(\'POINT({{longitudeInternalLabel}} {{latitudeInternalLabel}})\'),4326)
                            ELSE geom
                          END),
                          billingbbl=\'{{condominiumBillingBbl}}\',
                        WHERE
                          tl=\'{{bblTaxLotIn}}\'
                          AND tb=\'{{bblTaxBlock}}\'
                          AND upper(borough) = \'{{firstBoroughName}}\'
                          AND processingflag IS NULL`;

  if(data.latitude && data.longitude) {
    // console.log('Updating facilities');

    var insert = Mustache.render(insertTemplate, {
      
      // data. comes from api response
      latitudeInternalLabel: data.latitudeInternalLabel,
      longitudeInternalLabel: data.longitudeInternalLabel,
      billingbbl: data.billingbbl,
      bblTaxLotIn: data.bblTaxLotIn,
      bblTaxBlock: data.bblTaxBlock,
      firstBoroughName: data.firstBoroughName,

      // row. comes from original table row from psql query
      tl: row.tl,
      borough: row.borough,
      tb: row.tb
    })

    // console.log(insert);

    db.none(insert)
    .then(function(data) {
      i++;
      // console.log(i,nullGeomResults.length)
      if (i<nullGeomResults.length) {
         addressLookup1(nullGeomResults[i])
      } else {
        console.log('Done!')
      }
      
    })
    .catch(function(err) {
      console.log(err);
    })

  } else {
    // console.log('Response did not include a lat/lon, skipping...');
    i++;
        // console.log(i,nullGeomResults.length)
        if (i<nullGeomResults.length) {
           addressLookup1(nullGeomResults[i])
        }
  }
}