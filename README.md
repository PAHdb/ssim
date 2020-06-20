# SSIM
This is an implementation of the algorithm for calculating the Structural SIMilarity (SSIM) index between two images.

This is the IDL implementation by Dr. Christiaan Boersma (Christiaan.Boersma@nasa.gov) that has been ported from the Matlab version available at [www.cns.nyu.edu/~lcv/ssim/ssim_index.m](http://www.cns.nyu.edu/~lcv/ssim/ssim_index.m) and used in the publication:

--- Boersma, C., Bregman, J., Allamandola, L.J., "The Charge State of Polycyclic Aromatic Hydrocarbons across a Reflection Nebula, an H ii Region, and a Planetary Nebula", 2018, ApJ, 858, 67 ---


When using this code, please refer to:

--- Wang, Z., Bovik, A.C., Sheikh, H.R., Simoncelli, E.P., "Image quality assessment: From error visibility to structural similarity", 2004, IEEE Transactios on Image Processing, 13, 600 ---

Note that the scikit-image package offers a Python implementation of the SSIM algorithm in its metrics module ([skimage.metrics.structural_similarity](https://scikit-image.org/docs/stable/api/skimage.metrics.html#skimage.metrics.structural_similarity)).

## Inputs
1. img1: the first image being compared.
2. img2: the second image being compared.
3. K: constants in the SSIM index formula (see the above reference). Default value: K = [0.01 0.03].
4. window: local window for statistics (see the above reference). Default window is Gaussian.
5. L: dynamic range of the images. default: L = 255.

## Outputs
1. mssim: the mean SSIM index value between 2 images. If one of the images being compared is regarded as perfect quality, then mssim can be considered as the quality measure of the other image. If img1 = img2, then mssim = 1.
2. SSIM_MAP: the SSIM index map of the test image.

## Basic Usage
Given 2 test images img1 and img2, whose dynamic range is 0-255:


```
mssim = SSIM(img1, img2)
```
## Advanced Usage
User defined parameters. For example


```
K = [0.05 0.05]
```

```
window = INTARR(8,8) + 1
```
```
L = 100
```

```
mssim = SSIM(img1, img2, K, window, L, SSIM_MAP=ssim_map)
```
## Authors
* **Christiaan Boersma** - *IDL port* - [PAHdb](https://github.com/PAHdb)
* **Zhou Wang** - *Initial work*.
* **Alan C. Bovik** - *Initial work*.
* **Hamid R. Sheikh** - *Initial work*.
* **Eero P. Simoncelli** - *Initial work*.

## License
This project is licensed under the BSD 3-Clause License - see the
[LICENSE](LICENSE) file for details

## Acknowledgments
* Zhou Wang and collaborators - [www.cns.nyu.edu/~lcv/ssim](http://www.cns.nyu.edu/~lcv/ssim/)
* The NASA Ames PAH IR Spectroscopic Database Team
* The Astrophysics & Astrochemistry Laboratory at NASA Ames Research
  Center - [www.astrochemistry.org](http://www.astrochemistry.org)
