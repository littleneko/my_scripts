# my_doxygen

This is the doxygen conf file for generate a document for mysql-server 5.7.x.

## How to use

1. Install **doxygen** 1.8.11 or higher. Distributions are available here at [http://www.doxygen.nl/](https://www.doxygen.nl/index.html).

After installing doxygen, verify the version number:

```bash
shell> doxygen --version
1.8.18
```

2. Install [PlantUML](http://plantuml.com/download.html).

3. Set the `PLANTUML_JAR_PATH environment` to the location where you installed PlantUML. For example:

```bash
shell> export PLANTUML_JAR_PATH=path-to-plantuml.jar
```

4. Install the [Graphviz](http://www.graphviz.org/) **dot** command.

After installing Graphviz, verify dot availability. For example:

```bash
shell> dot -V
dot - graphviz version 2.44.0 (0)
```

5. Edit the doxyfile

You should edit this item yourself.

  * `PROJECT_NUMBER`: Project num show in front page
  * `OUTPUT_DIRECTORY`: Html output dir

You maybe want to edit this item:

  * `INPUT`: If you only want to generate the document for a sub module
  * `EXCLUDE`: If you want to generate the document in has been exclude
  * `PREDEFINED`: If you find some func not be recognised
  * `HAVE_DOT`: If you don't want to generate the dot, example: call and caller graph
  * `DOT_NUM_THREADS`: Make th decision yourself
  * `UML_LOOK`: If you don't want to generate UML
  * `DOT_IMAGE_FORMAT`: If you want to generate png
  * `DOT_GRAPH_MAX_NODES`

6. Change location to the top-level directory of your MySQL source distribution and do the following:

```bash
shell> cd your-mysql-source-directory
shell> doxygen path/to/your/doxyfile
```

> Must run the doxygen cmd in mysql src root dir.

Assuming that the build executed successfully, view the generated output using a browser. For example:

```bash
shell> firefox doxygen/html/index.html
```

> The `doxygen_resources` is copping from mysql 8.0

Reference:
[1]. https://dev.mysql.com/doc/refman/8.0/en/source-installation-doxygen.html

