# EIT_FRFoM: An Imaged Based EIT Figure-of-Merit
The project provides a simple and reproducible methodology for the universal evaluation of the performance of electrical impedance tomography (EIT) systems using reconstructed images.

## Background
EIT is an impedance measurement technique that uses the tomography principle to reconstruct an image that illustrates the inner impedance distribution of the subject under test (SUT), it's basic working principle is as shown below:

<img src="imageFiles/1-bg.JPG" width="500" >

## Universal Figure-of-Merit (FoM) for EIT system evaluation
Based on objective full referencing (FR), this evaluation method provides a visually distinguishable hot colormap and quantitative image quality metrics. 

Using the FR metric, a imaged based EIT FoM is proposed:

<img src="imageFiles/2-fom.JPG" width="1000" >

__P<sub>system</sub>__ is the system power consumption

__*f*__ is the system EIT operating frequency

__Global FR__ is the quantitative image quality metric

__Frame Rate__ is the system image frame per second

The new FoM addresses the issues where common electrical parameters used in EIT hardware evaluation are not directly related to the quality of EIT images.

## Methodology
Ensuring a fair evaluation and comparison of EIT system performance requires:
* Using identical SUT can produce a reference image (ground truth) while capable of being measured by hardware;
* Using identical reconstruction software (inverse problem solver);
* Using identical FoM factor for evaluation.

As an imaging system, the comparison should be ultimately demonstrated in terms of an image quality factor, and to be widely adopted, the method should be simple and reproducible.
### 1. Identical SUT
For hardware system evaluation, a resistive phantom is used and is shown below: 

<img src="ImageFiles/3-resis.JPG" width="500" >

By skipping electrodes, this phantom can be used for 8, 16, or 32 electrode systems. 16 electrode EIT system was chosen as an illustrative example here. 

The 16 electrode ideal dataset for the reference image (ground truth) was generated through simulation using the resistive phantom with __adjacent EIT scan__, the two __X resistive elements__ was toggled between 68.1 Ω and 0 Ω for homogeneous and inhomogeneous datasets for EIT differential imaging. 

The 16 electrode ground truth image datasets are provided in __sample_data.mat__ (in codeFiles folder) as __ref__ (inhomogeneous) and __data__(homogeneous).
