import pandas as pd
import matplotlib.pyplot as plt

aggregate_sql = '''
SELECT  sum(UnitsRes::numeric) as UnitsRes,
        sum(LotArea::numeric) as LotArea,
        sum(BldgArea::numeric) as BldgArea,
        sum(ComArea::numeric) as ComArea,
        sum(ResArea::numeric) as ResArea,
        sum(OfficeArea::numeric) as OfficeArea,
        sum(RetailArea::numeric) as RetailArea,
        sum(GarageArea::numeric) as GarageArea,
        sum(StrgeArea::numeric) as StrgeArea,
        sum(FactryArea::numeric) as FactryArea,
        sum(OtherArea::numeric) as OtherArea,
        sum(AssessLand::numeric) as AssessLand,
        sum(AssessTot::numeric) as AssessTot,
        sum(ExemptTot::numeric) as ExemptTot,
        sum(FIRM07_FLAG::numeric) as FIRM07_FLAG,
        sum(PFIRM15_FLAG::numeric) as PFIRM15_FLAG
FROM {0}
{1}
'''
def create_aggregate(version_0, version_1, version_2, condition, con, sql, title):
    df0 = pd.read_sql(sql=sql.format(version_0, condition), con=con)
    df0['version'] = version_0
    df1 = pd.read_sql(sql=sql.format(version_1, condition), con=con)
    df1['version'] = version_1
    df2 = pd.read_sql(sql=sql.format(version_2, condition), con=con)
    df2['version'] = version_2
    summary = pd.concat([df2,df1, df0], sort=False)
    summary.index = summary.version
    summary_pct = summary.iloc[:, :-1].pct_change()
    
    plt.figure(figsize=(15, 10))
    plt.plot(range(16), summary_pct.iloc[2, :], color = 'red', label=f'{version_0} - {version_1}')
    plt.plot(range(16), summary_pct.iloc[1, :], color = 'blue', label=f'{version_1} - {version_2}')
    plt.hlines(0, 16, 0) #0 reference line
    plt.xticks(range(16), summary_pct.columns, rotation=70)
    plt.title(title)
    plt.legend()
    plt.show()