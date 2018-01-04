# Chan-Vese-model
A MATLAB implementation of Chan-Vese model for image segmentation, using idea proposed by Chan and Vese. For detailed information, please refer to the paper ["Active Contours Without Edges"](http://ieeexplore.ieee.org/abstract/document/902291/), or [my blog](https://gaomingqi.github.io/posts/2016/12/blog-post-1/).

### Usage
* The test images are placed in "images" folder;  
* You can load the existing initial contours from "initial contours" folder or select a polygonal region by hand;  
* Also, you can record the evolution process of active contours in a GIF file;
* Segmentation results will be saved in "results" folder;
* __Run "demo_CV.m" directly to get segmentation results__.

`NOTE`: To use it as academic purpose, please cite the following papers: 

>[1] [Active Contours Without Edges](http://ieeexplore.ieee.org/abstract/document/902291/), Tony F. Chan and Luminita A. Vese. __IEEE Trans on Image Processing__, 2001.  
>[2] [Level Set Evolution Without Re-initialization: A New Variational Formulation](http://ieeexplore.ieee.org/document/1467299/), Chunming Li, Chenyang Xu, Changfeng Gui, and Martin D. Fox. __IEEE CVPR__, 2005.
