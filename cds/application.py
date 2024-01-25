import cdstoolbox as ct

@ct.application(title='Retrieve Data')
# @ct.input.city(
#     'city',
#      default='Beijing',
#      label='Selected city',
#      description= 'Select city to extract time series from.',
#      help= 'City selection.',
# )
@ct.output.download()
def application():
    """
    Application main steps:

    - retrieve a variable from CDS Catalogue
    - produce a link to download it.
    """

    

    data = ct.catalogue.retrieve(
        'derived-utci-historical',
        {
            'variable': 'universal_thermal_climate_index',
            'product_type': 'consolidated_dataset',
            # 'year': [
            #     '2010', '2011', '2012',
            #     '2013', '2014',
            # ],
            'year':['2010'],
            # 'month': [
            #     '01', '02', '03',
            #     '04', '05', '06',
            #     '07', '08', '09',
            #     '10', '11', '12',
            # ],
            # 'month':['01'],
            # 'day': [
            #     '01', '02', '03',
            #     '04', '05', '06',
            #     '07', '08', '09',
            #     '10', '11', '12',
            #     '13', '14', '15',
            #     '16', '17', '18',
            #     '19', '20', '21',
            #     '22', '23', '24',
            #     '25', '26', '27',
            #     '28', '29', '30',
            #     '31',
            # ]
        }
    )

    city = {'lon':116.39723,'lat':39.9075}
    lon = city['lon']
    lat = city['lat']

    data_location = ct.geo.extract_point(ct.cube.select(data), extent=[lon-0.25, lon+0.25, lat-0.25, lat+0.25])

    monthly_mean = ct.climate.monthly_mean(data_location)
    # monthly_std = ct.climate.monthly_std(data_location)
    # daily_mean = ct.climate.daily_mean(data_location)
    # daily_std = ct.climate.daily_std(data_location)

    # fig = ct.chart.line(
    #     daily_mean,
    #     error_y=daily_std,
    #     scatter_dict={'name': 'Daily'},
    #     layout_dict={'title': 'Monthly/Daily mean with standard deviation'}
    # )

    # fig = ct.chart.line(
    #     monthly_mean,
    #     fig=fig,
    #     error_y=monthly_std,
    #     scatter_dict={'name': 'Monthly'}
    # )

    return monthly_mean