Protein Projector
========================

This repo exposes `Protein Projector <https://doi.org/10.1093/bioadv/vbaf266>`__ implemented in 
`Cell Mapping Toolkit Coembedding <https://github.com/idekerlab/cellmaps_coembedding>`__ 
as a `Docker container <https://www.docker.com/resources/what-container/>`__ and a
`DNAnexus Applet <https://documentation.dnanexus.com/faqs/developing-apps-and-applets>`__

For Developers
----------------

Below are instructions for creating the Docker image as well as
`DNAnexus Applet <https://documentation.dnanexus.com/faqs/developing-apps-and-applets>`__

Build Dependencies
--------------------------

* `Docker <https://www.docker.com/>`__
* `DNAnexus Python API dxpy <https://pypi.org/project/dxpy/>`__
* `Make <https://www.gnu.org/software/make/>`__


Creating Docker Image
-----------------------

The make target **dockerbuild** will copy over and adjust DNAnexus applet files from ``platforms/dnanexus/protein_projector``
and put them under ``build/protein_projector``. This target will also create a Docker image and store it
under the ``build/protein_projector/resources``. The version of the image and the applet
will be based on the version of cellmaps_coembedding package as specified in ``docker/Dockerfile``

.. code-block:: bash

    git clone https://github.com/digitaltumors/protein_projector
    make build/protein_projector/resources/protein_projector.tar.gz


Creating DNAnexus Applet
----------------------------

Code below assumes repo has already been cloned. The Docker image will be built if not done already.

.. code-block:: bash

    make applet
    cd build/protein_projector
    dx build -f -d <PROJECT ID>:/apps/protein_projector

Citation
----------------

Leah V Schaffer, Mayank Jain, Rami Nasser, Roded Sharan, Trey Ideker, 
Unifying proteomic technologies with ProteinProjector, 
Bioinformatics Advances, Volume 5, Issue 1, 2025, vbaf266, 
https://doi.org/10.1093/bioadv/vbaf266