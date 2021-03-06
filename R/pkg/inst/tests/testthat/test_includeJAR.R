#
# Licensed to the Apache Software Foundation (ASF) under one or more
# contributor license agreements.  See the NOTICE file distributed with
# this work for additional information regarding copyright ownership.
# The ASF licenses this file to You under the Apache License, Version 2.0
# (the "License"); you may not use this file except in compliance with
# the License.  You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
context("include an external JAR in SparkContext")

runScript <- function() {
  sparkHome <- Sys.getenv("SPARK_HOME")
  sparkTestJarPath <- "R/lib/SparkR/test_support/sparktestjar_2.10-1.0.jar"
  jarPath <- paste("--jars", shQuote(file.path(sparkHome, sparkTestJarPath)))
  scriptPath <- file.path(sparkHome, "R/lib/SparkR/tests/testthat/jarTest.R")
  submitPath <- file.path(sparkHome, paste("bin/", determineSparkSubmitBin(), sep = ""))
  combinedArgs <- paste(jarPath, scriptPath, sep = " ")
  res <- launchScript(submitPath, combinedArgs, capture = TRUE)
  tail(res, 2)
}

test_that("sparkJars tag in SparkContext", {
  testOutput <- runScript()
  helloTest <- testOutput[1]
  expect_equal(helloTest, "Hello, Dave")
  basicFunction <- testOutput[2]
  expect_equal(basicFunction, "4")
})
