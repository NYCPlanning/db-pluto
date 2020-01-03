import pandas as pd
import matplotlib.pyplot as plt
import numpy as np

null_sql = '''
SELECT
    count(*) as total,
    sum(case when a.borough is null then 1 else 0 end) as borough,
    sum(case when a.block is null then 1 else 0 end) as block,
    sum(case when a.lot is null then 1 else 0 end) as lot,
    sum(case when a.cd is null then 1 else 0 end) as cd,
    sum(case when a.ct2010 is null then 1 else 0 end) as ct2010,
    sum(case when a.cb2010 is null then 1 else 0 end) as cb2010,
    sum(case when a.schooldist is null then 1 else 0 end) as schooldist,
    sum(case when a.council is null then 1 else 0 end) as council,
    sum(case when a.zipcode is null then 1 else 0 end) as zipcode,
    sum(case when a.firecomp is null then 1 else 0 end) as firecomp,
    sum(case when a.policeprct is null then 1 else 0 end) as policeprct,
    sum(case when a.healtharea is null then 1 else 0 end) as healtharea,
    sum(case when a.sanitboro is null then 1 else 0 end) as sanitboro,
    sum(case when a.sanitsub is null then 1 else 0 end) as sanitsub,
    sum(case when a.address is null then 1 else 0 end) as address,
    sum(case when a.zonedist1 is null then 1 else 0 end) as zonedist1,
    sum(case when a.zonedist2 is null then 1 else 0 end) as zonedist2,
    sum(case when a.zonedist3 is null then 1 else 0 end) as zonedist3,
    sum(case when a.zonedist4 is null then 1 else 0 end) as zonedist4,
    sum(case when a.overlay1 is null then 1 else 0 end) as overlay1,
    sum(case when a.overlay2 is null then 1 else 0 end) as overlay2,
    sum(case when a.spdist1 is null then 1 else 0 end) as spdist1,
    sum(case when a.spdist2 is null then 1 else 0 end) as spdist2,
    sum(case when a.spdist3 is null then 1 else 0 end) as spdist3,
    sum(case when a.ltdheight is null then 1 else 0 end) as ltdheight,
    sum(case when a.splitzone is null then 1 else 0 end) as splitzone,
    sum(case when a.bldgclass is null then 1 else 0 end) as bldgclass,
    sum(case when a.landuse is null then 1 else 0 end) as landuse,
    sum(case when a.easements is null then 1 else 0 end) as easements,
    sum(case when a.ownertype is null then 1 else 0 end) as ownertype,
    sum(case when a.ownername is null then 1 else 0 end) as ownername,
    sum(case when a.lotarea is null then 1 else 0 end) as lotarea,
    sum(case when a.bldgarea is null then 1 else 0 end) as bldgarea,
    sum(case when a.comarea is null then 1 else 0 end) as comarea,
    sum(case when a.resarea is null then 1 else 0 end) as resarea,
    sum(case when a.officearea is null then 1 else 0 end) as officearea,
    sum(case when a.retailarea is null then 1 else 0 end) as retailarea,
    sum(case when a.garagearea is null then 1 else 0 end) as garagearea,
    sum(case when a.strgearea is null then 1 else 0 end) as strgearea,
    sum(case when a.factryarea is null then 1 else 0 end) as factryarea,
    sum(case when a.otherarea is null then 1 else 0 end) as otherarea,
    sum(case when a.areasource is null then 1 else 0 end) as areasource,
    sum(case when a.numbldgs is null then 1 else 0 end) as numbldgs,
    sum(case when a.numfloors is null then 1 else 0 end) as numfloors,
    sum(case when a.unitsres is null then 1 else 0 end) as unitsres,
    sum(case when a.unitstotal is null then 1 else 0 end) as unitstotal,
    sum(case when a.lotfront is null then 1 else 0 end) as lotfront,
    sum(case when a.lotdepth is null then 1 else 0 end) as lotdepth,
    sum(case when a.bldgfront is null then 1 else 0 end) as bldgfront,
    sum(case when a.bldgdepth is null then 1 else 0 end) as bldgdepth,
    sum(case when a.ext is null then 1 else 0 end) as ext,
    sum(case when a.proxcode is null then 1 else 0 end) as proxcode,
    sum(case when a.irrlotcode is null then 1 else 0 end) as irrlotcode,
    sum(case when a.lottype is null then 1 else 0 end) as lottype,
    sum(case when a.bsmtcode is null then 1 else 0 end) as bsmtcode,
    sum(case when a.assessland is null then 1 else 0 end) as assessland,
    sum(case when a.assesstot is null then 1 else 0 end) as assesstot,
    sum(case when a.exempttot is null then 1 else 0 end) as exempttot,
    sum(case when a.yearbuilt is null then 1 else 0 end) as yearbuilt,
    sum(case when a.yearalter1 is null then 1 else 0 end) as yearalter1,
    sum(case when a.yearalter2 is null then 1 else 0 end) as yearalter2,
    sum(case when a.histdist is null then 1 else 0 end) as histdist,
    sum(case when a.landmark is null then 1 else 0 end) as landmark,
    sum(case when a.builtfar is null then 1 else 0 end) as builtfar,
    sum(case when a.residfar is null then 1 else 0 end) as residfar,
    sum(case when a.commfar is null then 1 else 0 end) as commfar,
    sum(case when a.facilfar is null then 1 else 0 end) as facilfar,
    sum(case when a.borocode is null then 1 else 0 end) as borocode,
    sum(case when a.bbl is null then 1 else 0 end) as bbl,
    sum(case when a.condono is null then 1 else 0 end) as condono,
    sum(case when a.tract2010 is null then 1 else 0 end) as tract2010,
    sum(case when a.xcoord is null then 1 else 0 end) as xcoord,
    sum(case when a.ycoord is null then 1 else 0 end) as ycoord,
    sum(case when a.zonemap is null then 1 else 0 end) as zonemap,
    sum(case when a.zmcode is null then 1 else 0 end) as zmcode,
    sum(case when a.sanborn is null then 1 else 0 end) as sanborn,
    sum(case when a.taxmap is null then 1 else 0 end) as taxmap,
    sum(case when a.edesignum is null then 1 else 0 end) as edesignum,
    sum(case when a.appbbl is null then 1 else 0 end) as appbbl,
    sum(case when a.appdate is null then 1 else 0 end) as appdate,
    sum(case when a.plutomapid is null then 1 else 0 end) as plutomapid,
    sum(case when a.version is null then 1 else 0 end) as version,
    sum(case when a.sanitdistrict is null then 1 else 0 end) as sanitdistrict,
    sum(case when a.healthcenterdistrict is null then 1 else 0 end) as healthcenterdistrict,
    sum(case when a.firm07_flag is null then 1 else 0 end) as firm07_flag,
    sum(case when a.pfirm15_flag is null then 1 else 0 end) as pfirm15_flag,
    sum(case when a.rpaddate is null then 1 else 0 end) as rpaddate,
    sum(case when a.dcasdate is null then 1 else 0 end) as dcasdate,
    sum(case when a.zoningdate is null then 1 else 0 end) as zoningdate,
    sum(case when a.landmkdate is null then 1 else 0 end) as landmkdate,
    sum(case when a.basempdate is null then 1 else 0 end) as basempdate,
    sum(case when a.masdate is null then 1 else 0 end) as masdate,
    sum(case when a.polidate is null then 1 else 0 end) as polidate,
    sum(case when a.edesigdate is null then 1 else 0 end) as edesigdate
FROM {} a
{}
'''

def create_plot(summary, version_0, version_1, version_2, title):
    df = summary.diff()
    plt.figure(figsize=(6, 30))
    num_col = len(df.columns)
    diff0 = df.loc[version_0,:]
    diff1 = df.loc[version_1,:]
    plt.plot(diff0, range(num_col), label = f'{version_0} - {version_1}', color = 'red')
    plt.plot(diff1, range(num_col), label = f'{version_1} - {version_2}', color = 'blue')
    plt.vlines(0, 0, num_col)

    for i in range(num_col):
        if abs(diff0[i]) >= 10000:
            plt.text(x = diff0[i] , y = i - 0.15, s = '{}'.format(diff0[i]), size = 10, color = 'red')
        else: 
            pass
    for i in range(num_col):
        if abs(diff1[i]) >= 10000:
            plt.text(x = diff1[i] , y = i - 0.15, s = '{}'.format(diff1[i]), size = 10, color = 'blue')
        else: 
            pass
    plt.yticks(range(num_col), df.columns, rotation='horizontal')
    plt.title('Null 0 Counts Comparison')
    plt.legend()
    plt.show()
    
def create_summary(version_0, version_1, version_2, sql, condition, con):
    df0 = pd.read_sql(sql=null_sql.format(version_0, condition), con=con)
    df1 = pd.read_sql(sql=null_sql.format(version_1, condition), con=con)
    df2 = pd.read_sql(sql=null_sql.format(version_2, condition), con=con)
    summary = pd.concat([df2, df1, df0], sort=False)
    summary.index = [version_2, version_1, version_0]
    return summary