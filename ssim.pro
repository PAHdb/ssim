;----------------------------------------------------------------------
; This is an implementation of the algorithm for calculating the
; Structural SIMilarity (SSIM) index between two images
;
; This is the IDL implementation by Dr. Christiaan Boersma
; (Christiaan.Boersma@nasa.gov) that has been ported from the Matlab
; version available at http://www.cns.nyu.edu/~lcv/ssim/ssim_index.m.
;
; Please refer to the following paper
;
; Z. Wang, A. C. Bovik, H. R. Sheikh, and E. P. Simoncelli, "Image
; quality assessment: From error visibility to structural similarity,"
; IEEE Transactios on Image Processing, vol. 13, no. 4, pp. 600-612,
; Apr. 2004.
;
;----------------------------------------------------------------------
; Permission to use, copy, or modify this software and its documentation
; for educational and research purposes only and without fee is hereby
; granted, provided that this copyright notice and the original authors'
; names appear on all copies and supporting documentation. This program
; shall not be used, rewritten, or adapted as the basis of a commercial
; software or hardware product without first obtaining permission of the
; authors. The authors make no representations about the suitability of
; this software for any purpose. It is provided "as is" without express
; or implied warranty.
;----------------------------------------------------------------------
;
;Input : (1) img1: the first image being compared
;        (2) img2: the second image being compared
;        (3) K: constants in the SSIM index formula (see the above
;            reference). defualt value: K = [0.01 0.03]
;        (4) window: local window for statistics (see the above
;            reference). default widnow is Gaussian given by
;            window = fspecial('gaussian', 11, 1.5);
;        (5) L: dynamic range of the images. default: L = 255
;
;Output: (1) mssim: the mean SSIM index value between 2 images.
;            If one of the images being compared is regarded as
;            perfect quality, then mssim can be considered as the
;            quality measure of the other image.
;            If img1 = img2, then mssim = 1.
;        (2) SSIM_MAP: the SSIM index map of the test image.
;
;Basic Usage:
;   Given 2 test images img1 and img2, whose dynamic range is 0-255
;
;   mssim = SSIM(img1, img2)
;
;Advanced Usage:
;   User defined parameters. For example
;
;   K = [0.05 0.05]
;   window = INTARR(8,8) + 1
;   L = 100
;   mssim = SSIM(img1, img2, K, window, L, SSIM_MAP=ssim_map)
;========================================================================

FUNCTION SSIM,img1,img2,K,window,L,SSIM_MAP=SSIM_MAP

  COMPILE_OPT IDL2

  ON_ERROR, 2

  IF N_PARAMS() LT 2 THEN $
     MESSAGE,"NEED TWO IMAGES"

  dim1 = SIZE(img1, /DIMENSIONS)

  IF NOT ARRAY_EQUAL(dim1, SIZE(img2, /DIMENSIONS)) THEN $
     MESSAGE,"DIMENSIONS OF BOTH IMAGES DO NOT AGREE"

  IF N_ELEMENTS(dim1) NE 2 THEN $
     MESSAGE,"IMAGE HAS WRONG NUMBER OF DIMENSIONS"

  IF N_PARAMS() LT 3 THEN $
     K = [0.01, 0.03]

  IF K[0] LT 0 OR K[1] LT 0 THEN $
     MESSAGE,"K'S CANNOT BE NEGATIVE"

  K = DOUBLE(K)

  IF N_PARAMS() LT 4 THEN $
     window = GAUSSIAN_FUNCTION([1.5D, 1.5], WIDTH=11)

  dimw = SIZE(window, /DIMENSIONS)

  IF dimw[0] * dimw[1] LT 4 OR $
     dimw[0] GT dim1[0] OR $
     dimw[1] GT dim1[1] OR $
     dimw[0] MOD 2 EQ 0 OR $
     dimw[1] MOD 2 EQ 0 THEN $
        MESSAGE,"WINDOW EITHER TOO SMALL, TOO BIG OR EVEN"

  IF dim1[0] LT dimw[0] OR dim1[1] LT dimw[1] THEN $
     MESSAGE,"IMAGE IS TOO SMALL FOR WINDOW"

  window /= TOTAL(window)

  IF N_PARAMS() LT 5 THEN $
     L = 255

  L = DOUBLE(L)

  C = (K * L)^2

  img1 = DOUBLE(img1)

  img2 = DOUBLE(img2)

  mu1 = CONVOL(img1, window, /EDGE_ZERO)

  mu2 = CONVOL(img2, window, /EDGE_ZERO)

  mu1_sq = mu1^2

  mu2_sq = mu2^2

  mu1_mu2 = mu1 * mu2

  sigma1_sq = CONVOL(img1^2, window, /EDGE_ZERO) - mu1_sq

  sigma2_sq = CONVOL(img2^2, window, /EDGE_ZERO) - mu2_sq

  sigma12 = CONVOL(img1 * img2, window, /EDGE_ZERO) - mu1_mu2

  IF C[0] GT 0 AND C[1] GT 0 THEN $
     ssim_map = ((2D * mu1_mu2 + C[0]) * (2D * sigma12 + C[1])) / $
                ((mu1_sq + mu2_sq + C[0]) * (sigma1_sq + sigma2_sq + C[1])) $
  ELSE BEGIN
     numerator1 = 2D * mu1_mu2 + C[0]
     numerator2 = 2D * sigma12 + C[1]
     denominator1 = mu1_sq + mu2_sq + C[0]
     denominator2 = sigma1_sq + sigma2_sq + C[1]
     ssim_map = MAKE_ARRAY(dim1[0], dim1[1], VALUE=1D)
     index = WHERE(denominator1 * denominator2 GT 0)
     ssim_map[index] = (numerator1[index] * numerator2[index]) / $
                       (denominator1[index] * denominator2[index])
     index = WHERE(denominator1 NE 0 AND denominator2 EQ 0)
     ssim_map[index] = numerator1[index] / $
                       denominator1[index]
  ENDELSE

  RETURN,MEAN(ssim_map[dimw[0]/2:-dimw[0]/2-1,dimw[1]/2:-dimw[1]/2-1])
END
