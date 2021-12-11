FROM yangyangfu/jmodelica_py3

# root 
USER root

### ====================================================================================
## install env for OPC: optimizer, nonlinear system identifier
RUN conda update conda && \
    conda config --add channels conda-forge && \
    conda install pip \
    scikit-learn \
    casadi \
    matplotlib \
    joblib && \
    conda clean -ya

### ================
#  need install energyplus
#  need install energyplustofmu 
ENV UBUNTU_VERSION 18.04
######################
# EnergyPlus Docker
######################
# This is not ideal. The tarballs are not named nicely and EnergyPlus versioning is strange
ENV ENERGYPLUS_VERSION 9.4.0
ENV ENERGYPLUS_TAG v9.4.0
ENV ENERGYPLUS_SHA 998c4b761e

# This should be x.y.z, but EnergyPlus convention is x-y-z
ENV ENERGYPLUS_INSTALL_VERSION 9-4-0

# Downloading from Github
# e.g. https://github.com/NREL/EnergyPlus/releases/download/v8.9.0/EnergyPlus-8.9.0-40101eaafd-Linux-x86_64.sh
ENV ENERGYPLUS_DOWNLOAD_BASE_URL https://github.com/NREL/EnergyPlus/releases/download/$ENERGYPLUS_TAG
ENV ENERGYPLUS_DOWNLOAD_FILENAME EnergyPlus-$ENERGYPLUS_VERSION-$ENERGYPLUS_SHA-Linux-Ubuntu$UBUNTU_VERSION-x86_64.sh
ENV ENERGYPLUS_DOWNLOAD_URL $ENERGYPLUS_DOWNLOAD_BASE_URL/$ENERGYPLUS_DOWNLOAD_FILENAME


# Collapse the update of packages, download and installation into one command
# to make the container smaller & remove a bunch of the auxiliary apps/files
# that are not needed in the container

RUN apt-get update && apt-get install -y ca-certificates curl \
    && rm -rf /var/lib/apt/lists/* \
    && curl -SLO $ENERGYPLUS_DOWNLOAD_URL \
    && chmod +x $ENERGYPLUS_DOWNLOAD_FILENAME \
    && echo "y\r" | ./$ENERGYPLUS_DOWNLOAD_FILENAME \
    && rm $ENERGYPLUS_DOWNLOAD_FILENAME \
    && cd /usr/local/EnergyPlus-$ENERGYPLUS_INSTALL_VERSION \
    && rm -rf DataSets Documentation ExampleFiles WeatherData MacroDataSets PostProcess/convertESOMTRpgm \
    PostProcess/EP-Compare PreProcess/FMUParser PreProcess/ParametricPreProcessor PreProcess/IDFVersionUpdater

# Remove the broken symlinks
RUN cd /usr/local/bin \
    && find -L . -type l -delete

# Add in the test files
#ADD test /usr/local/EnergyPlus-$ENERGYPLUS_INSTALL_VERSION/test_run
#RUN cp /usr/local/EnergyPlus-$ENERGYPLUS_INSTALL_VERSION/Energy+.idd \
#        /usr/local/EnergyPlus-$ENERGYPLUS_INSTALL_VERSION/test_run/

# Add a symbolink to Energy+.idd
RUN ["ln", "-s", "/usr/local/EnergyPlus-9-4-0/Energy+.idd", "/usr/local/Energy+.idd"]

VOLUME /var/simdata
CMD [ "/bin/bash" ]

### ===========================================================================================
### install testcase dependency
# install Modelica dependency
COPY ./libraries /usr/local/JModelica/ThirdParty/MSL

### install EnergyPlusToFMU
COPY ./EnergyPlusToFMU-v3.1.0 $HOME/EnergyPlusToFMU-v3.1.0

### =============================
USER developer
WORKDIR $HOME 
# Avoid warning that Matplotlib is building the font cache using fc-list. This may take a moment.
# This needs to be towards the end of the script as the command writes data to
# /home/developer/.cache
RUN python -c "import matplotlib.pyplot"