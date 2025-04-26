{:user  {:jvm-opts ^:replace ["-XX:-OmitStackTraceInFastThrow"]
         :repl-options {:timeout 180000}
         :plugins [[lein-ancient "1.0.0-RC3"]
                   [lein-monolith "1.7.1"]
                   [lein-licenses "0.2.2"]
                   [lein-pprint "1.3.2"]]
         
         :dependencies [[criterium "0.4.6"]
                        [org.clojure/tools.namespace "1.3.0"]]}
 :auth {:repository-auth {#"https:\/\/maven.pkg.github.com\/.+" {:username :env/GITHUB_USERNAME
                                                                 :password :env/GITHUB_TOKEN}}}}
