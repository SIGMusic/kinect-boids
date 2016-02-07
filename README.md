# Kinect-Boids
EOH 2015-2016 project for SIGMusic

#### Linked repositories
  - Lights: https://github.com/SIGMusic/tonal-lightfield
  - Sound: https://github.com/SIGMusic/boids-sound

## Idea
The idea behind this project is to create an exhibit where anyone can walk in and start interacting to create music. 
It shouldn't be hard for anyone to see how their actions affect the kinds of sounds that are being made. 
Boids (bird-oids) are an idea from the graphics realm where there are these bird like polygons that interact with each other to continuously fly throughout the simulation. The Kinect will be able to interact with these boids, while each one (or flock) carries a sound synthesizer based on different attributes.

## Requirements
1. Processing: https://processing.org/
  - oscP5
  - Kinect v2 for Processing
2. Kinect v2 SDK: http://www.microsoft.com/en-us/download/details.aspK?id=44561
3. Sound: ChucK - http://chuck.cs.princeton.edu/
4. Python
  - Python - http://www.python.org/getit/
  - pyOSC - https://trac.v2.nl/wiki/pyOSC
   - simpleOSC - http://ixi-audio.net/content/download/SimpleOSC_0.3.2.zip

### Installation Instructions:

##### pyOSC and simpleOSC

  1.  Open command prompt and confirm Python is installed correctly by typing:
  
          python --version
    
      You should see the version number of your python installation appear.
    
  2.  Extract the pyOSC archive
  3.  Change the active directory of the command prompt to the directory of the extracted files. In Windows, this is:

          cd c:\Users\user\downloads\pyOSC-directory
  4.  Type in the following command:

          python setup.py install
          
  5.  Repeat steps 2-4 with the simpleOSC archive

##### Libraries in Processing

  1. Click on Sketch on the top bar of Processing and import libraries

  2. Search for the library and click install

## Testing


