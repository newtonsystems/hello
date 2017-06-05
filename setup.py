from setuptools import setup

from app import __version__


setup(
    name="hello",
    version=__version__,
    description="gRPC server",
    long_description="A dockerized hello gRPC server.",
    keywords="grpc, python, microservice",
    author="James Tarball <james.tarball@newtonsystems.co.uk>",
    author_email="james.tarball@newtonsystems.co.uk",
    url="https://github.com/newtonsystems/hello",
    license="newtonsystems",
    packages=["app"],
    zip_safe=False,
    include_package_data=True,
    classifiers=[
        "Programming Language :: Python",
        "Topic :: Software Development :: Libraries :: Python Modules",
        "Environment :: Web Environment",
        "Programming Language :: Python :: 2.6",
        "Programming Language :: Python :: 2.7",
    ],
    entry_points={
        'console_scripts': [
            'run-app=app.service:serve',
        ],
    },
)
