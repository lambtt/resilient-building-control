# Framework for Resilient Building Control

# 1. Environment Installation
This framework can run in two ways, one is a virtual Python environment based on conda, and the other is through a containerized docker application.

## 1.1 Conda Environment

To install the conda vritul environment for this repository, please first make sure `conda` command is available in your local computer.

If conda is successufully installed, 
1. open a terminal and direct to the root folder for this repository, such as `XXX/resilient-building-control`
2. install the virtual environment by typing:
      
        conda env create -f residential-building-control.yml

  This will create a predefined runtime envirnpment in your local computer.
3. check if the environment is successfully installed by typing:

        conda env list

  if an envrionment named `res-building-control` is listed, then you succeed. 


## 1.2 Docker Environment

Make sure Docker is installed in your local computer.

If docker is installed and runing, then
1. open a terminal and direct to the root folder for this repository, such as `XXX/resilient-building-control`
2. build a docker image in your local computer by typing:

      make build

  This will calls `Dockerfile` in your current directory and parse it to build a docker image.

3. check if the environment is successfully installed by typing:

    docker image ls
  
  If an image named `res_building_control` shows up, then it is built.


# 2 Activate Environment

## 2.1 Conda Environent

1. Direct to the root of this repository, and open a terminal. 

2. Activate the conda environment is actiavted by typing:

       conda activate res-building-control
3. Test if the environment is sucessfully installed by 

        cd ./testcases/1-test-ep-fmu
        python eplus_fmu.py


## 2.2 Docker Environment
Docker image is needs to be instantiated for each run. An example is provided in `/testcases/2-test-modelica-fmu/docker-example`.

1. Direct to the root of this repository, and open a terminal. 
2. Run the test example by:

    - compile the `test.mo` file in the jmdoelica docker, a `test.fmu` file will be successfully generated after compilation.

          bash compile.sh

    - simulate the generated fmu in jmodelica docker 

          bash simulate.sh


