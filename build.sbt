// See README.md for license details.

ThisBuild / scalaVersion := "2.13.18"
ThisBuild / version := "0.1.0"
ThisBuild / organization := "com.github.lassenorbjerg"

val chiselVersion = "7.7.0"

lazy val root = (project in file("."))
  .settings(
    name := "fpga-reverb",
    libraryDependencies ++= Seq(
      "org.chipsalliance" %% "chisel" % chiselVersion,
      "org.scalatest" %% "scalatest" % "3.2.19" % "test"
    ),
    scalacOptions ++= Seq(
      "-language:reflectiveCalls",
      "-deprecation",
      "-feature",
      "-Xcheckinit",
      "-Ymacro-annotations"
    ),
    addCompilerPlugin(
      "org.chipsalliance" % "chisel-plugin" % chiselVersion cross CrossVersion.full
    ),
    libraryDependencies += "edu.berkeley.cs" %% "chisel3" % chiselVersion,
    libraryDependencies += "edu.berkeley.cs" %% "chiseltest" % "0.6.2",
    libraryDependencies += "edu.berkeley.cs" % "ip-contributions" % "0.5.1"
  )
