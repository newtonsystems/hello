from setuptools import setup

setup(
    name='capture',
    version='1.0',
    long_description=__doc__,
    packages=['capture'],
    include_package_data=True,
    zip_safe=False,
    install_requires=['Flask'],
    entry_points={
        'console_scripts': [
            'run-capture=app.main:run',
        ],
    },
)
