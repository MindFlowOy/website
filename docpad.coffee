# DocPad Configuration

docpadConfig =
    # Collections
    #
    #database.findAllLive({
    #    articleOrder: $exists: true
    #   language: $startsWith: 'en'
    #}, [articleOrder:1, title:1 ]).on 'add', (document) ->
    #   console.log "Found ", document.attributes.relativePath
    #    console.log "Found ", document.attributes.language

    # A hash of functions that create collections
    collections:
        articlesEn: (database) ->
            database.findAllLive({
                relativeOutDirPath: 'index-articles/en'
                articleOrder: $exists: true
            }, [articleOrder:1, title:1 ])

         articlesFi: (database) ->
            database.findAllLive({
                relativeOutDirPath: 'index-articles/fi'
                articleOrder: $exists: true
            }, [articleOrder:1, title:1])


    plugins:
        ghpages:
            deployRemote: 'target'
            deployBranch: 'master'

    # =================================
    # Template Configuration

    # Template Data
    # Use to define your own template data and helpers that will be accessible to your templates
    # Complete listing of default values can be found here: http://docpad.org/docs/template-data
    templateData:

        locale:
            # English
            en:
                _name: "English"
                _param: "en_GB"
                nav:
                    home: "Home"
                meta:
                    description: "Meta description in English"

            # Finnish
            fi:
                _name: "suomi"
                _param: "fi_FI"
                nav:
                    home: "Alku"
                meta:
                    description: "Meta kuvaus suomeksi"

        # Specify some site properties
        site:
            # The production url of our website
            url: "http://www.mindflow.fi"

            # The default title of our website
            title: "MindFlow"

            getLang: (inPath) ->
                # takes the path of the currently processed file and extracts the name of the first
                # folder in the path and, if it's a language code, returns it.
                # Otherwise, return default language code
                #
                # Processing file in Finnish, relativeDirPath
                # fi-FI/articles/ -> fi
                # Processing file in English, relativePath
                # articles/about.home.html -> en
                if inPath.slice(0, 5) == 'fi-FI/'
                    'fi'
                else
                    'en'

            getPathWOLang: (inPath) ->
                # takes the path of the currently processed file and returns it without the language code
                #
                # Processing file in Finnish, relativePath
                # fi-FI/articles/about.home.html -> articles/about.home.html
                # Processing file in English, relativePath
                # articles/about.home.html  -> articles/about.home.html
                if inPath.slice(0, 5) == 'fi-FI/'
                    inPath.slice(6)

            # The website description (for SEO)
            description: """
                When your website appears in search results in say Google, the text here will be shown underneath your website's title.
                """

            # The website keywords (for SEO) separated by commas
            keywords: """
                place, your, website, keywoards, here, keep, them, related, to, the, content, of, your, website
                """

            # The website author's name
            author: "Vesa Lindfors"

            # The website author's email
            email: "vli@iki.fi"



            #"//cdnjs.cloudflare.com/ajax/libs/jquery/1.10.2/jquery.min.js"


        # -----------------------------
        # Helper Functions

        # Get the prepared site/document title
        # Often we would like to specify particular formatting to our page's title
        # we can apply that formatting here
        getPreparedTitle: ->
            # if we have a document title, then we should use that and suffix the site's title onto it
            if @document.title
                "#{@document.title} | #{@site.title}"
            # if our document does not have it's own title, then we should just use the site's title
            else
                @site.title

        # Get the prepared site/document description
        getPreparedDescription: ->
            # if we have a document description, then we should use that, otherwise use the site's description
            @document.description or @site.description

        # Get the prepared site/document keywords
        getPreparedKeywords: ->
            # Merge the document keywords with the site keywords
            @site.keywords.concat(@document.keywords or []).join(', ')


    # =================================
    # DocPad Events

    # Here we can define handlers for events that DocPad fires
    # You can find a full listing of events on the DocPad Wiki
    #
    events:

            # Server Extend
            # Used to add our own custom routes to the server before the docpad routes are added
            serverExtend: (opts) ->
                    # Extract the server from the options
                    {server} = opts
                    docpad = @docpad

                    # As we are now running in an event,
                    # ensure we are using the latest copy of the docpad configuraiton
                    # and fetch our urls from it
                    latestConfig = docpad.getConfig()
                    oldUrls = latestConfig.templateData.site.oldUrls or []
                    newUrl = latestConfig.templateData.site.url

                    # Redirect any requests accessing one of our sites oldUrls to the new site url
                    server.use (req,res,next) ->
                            if req.headers.host in oldUrls
                                    res.redirect(newUrl+req.url, 301)
                            else
                                    next()


    # =================================
    # Environment
    # Which environment we should load up
    # If not set, we will default the `NODE_ENV` environment variable, if that isn't set, we will default to `development`
    env: null  # default

    environments:
        development:
            templateData:
                site:
                    styles: [ "/styles/index.css" ]
                    scripts: [ "/scripts/main.js"
                    , "/scripts/common/ctrl/base.js"
                    , "/scripts/common/drctv/scroll-to.js"
                    , "/scripts/main-bootstrap.js"
                    , "/js/vendor/lodash.js"
                    , "/js/vendor/raf.js"
                    ,"/js/vendor/modernizr-2.6.2-respond-1.1.0.min.js"
                    , "/js/vendor/placeholders.min.js" ]

            plugins:
                livereload:
                    enabled: true
                 grunt:
                    enabled: false
                ignoreincludes:
                    ignoreExtensions: ['inc', 'abc']

        static:
            templateData:
                site:
                    styles: [ "/styles/index.css" ]
                    scripts: [ "/scripts/all.min.js" ]

            plugins:
                livereload:
                    enabled: false

                grunt:
                    gruntTasks: ["default"]

                ignoreincludes:
                    ignoreExtensions: ['inc', 'abc']



# Export the DocPad Configuration
module.exports = docpadConfig
