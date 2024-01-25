import cdstoolbox as ct
 
@ct.application(title='Hello World!')
@ct.output.figure()
def application():
    """
    HELLO WORLD!
    This is your first application using the CDS Toolbox.
    
    Here, 3 basic tasks:
    
    - retrieve the 2 meter temperature from the CDS Catalogue
    - print info about the data (see it in the 'Console' tab!)
    - show the data on a map.
    """

    data = ct.catalogue.retrieve(
        'reanalysis-era5-single-levels',
        {
            'variable': '2m_temperature',
            'product_type': 'reanalysis',
            'year': '2017',
            'month': '01',
            'day': '01',
            'time': '12:00',
            'grid': ['3', '3'],
        }
    )

    # Create a simple Magics map
    fig = ct.map.plot(data)
    # To learn how to create simple Magics map consult the beginer's How to guide:      https://cds.climate.copernicus.eu/toolbox/doc/how-to/21_how_to_make_a_map_with_magics_part1/21_how_to_make_a_map_with_magics_part1.html
    

    return fig
