module Constants exposing
    ( Book
    , ContactInfo
    , Job
    , Project
    , SimpleDate
    , SmallProject
    , Study
    , books
    , contactList
    , education
    , email
    , familiarSkills
    , jobs
    , name
    , proficientSkills
    , projects
    , smallProjects
    , tabTitle
    )

import FeatherIcons
import Language exposing (..)
import Material.Icons as Filled
import Material.Icons.Types exposing (Coloring(..))
import Phone
import Svg.Styled
import Time


tabTitle : Language -> String
tabTitle =
    translated "Currículum de César González" "César González's resume"


name : String
name =
    "César Gonzalez"


email : String
email =
    "ces.gonzalezortega@gmail.com"


phone : Phone.InternationalPhone
phone =
    { countryCode = 52
    , cityCode = 1
    , localPhoneNumber = 9995692551
    }


type alias ContactInfo msg =
    { href : String
    , text : String
    , icon : Svg.Styled.Svg msg
    }


contactList : Int -> List (ContactInfo msg)
contactList iconSize =
    [ { href = "mailto:" ++ email
      , text = email
      , icon = Svg.Styled.fromUnstyled <| Filled.email iconSize Inherit
      }
    , { href = "https://github.com/Chesare22"
      , text = "/Chesare22"
      , icon =
            Svg.Styled.fromUnstyled
                (FeatherIcons.github
                    |> FeatherIcons.withSize (toFloat iconSize)
                    |> FeatherIcons.toHtml []
                )
      }
    , { href = phone |> Phone.toWhatsAppUrl
      , text = phone |> Phone.toString
      , icon =
            Svg.Styled.fromUnstyled
                (FeatherIcons.smartphone
                    |> FeatherIcons.withSize (toFloat iconSize)
                    |> FeatherIcons.toHtml []
                )
      }
    ]


type alias Job =
    { title : Language.Language -> String
    , start : SimpleDate
    , end : Maybe SimpleDate
    , position : Language.Language -> String
    , description : Language.Language -> String
    }


type alias SimpleDate =
    { month : Time.Month
    , year : Int
    }


jobs : List Job
jobs =
    [ Job (always "MID Software")
        (SimpleDate Time.Mar 2022)
        (Just (SimpleDate Time.Apr 2025))
        (Language.translated "Ingeniero de Software Full-Stack" "Full-Stack Software Engineer")
        (Language.translated
            """
            Empresa enfocada en la facilitación de tareas administrativas en la industria médica y de construcción.
            Mis principales actividades incluyeron programar una aplicación web hecha en React y Django,
            donde pude implementar varios patrones de diseño funcionales que facilitaron la modificación del código fuente.
            También lideré el desarrollo de una aplicación WPF, donde creé una librería para consultar fácilmente datos almacenados en CTEs recursivos.
            """
            """
            Enterprise focused on the development of tools to help complex administrative work.
            My main duties included programming a web application made with React and Django,
            where I could implement various functional design patterns that facilitated the modification of our source code.
            I also led the development of a WPF application, where I created a library to easily query data stored in recursive CTEs.
            """
        )
    , Job (always "Sumerian")
        (SimpleDate Time.Jun 2020)
        (Just <| SimpleDate Time.Jul 2022)
        (Language.translated "Ingeniero de Software" "Software Engineer")
        (Language.translated
            """
            Una startup formada por mí y un equipo de compañeros capaces.
            Nuestros principales proyectos fueron un exitoso blog de música y una pequeña aplicación para la administración de facturas.
            Mis tareas incluyeron la participación en reuniones con clientes dirigidas a entender requisitos y proponer soluciones, la programación en Vue y React,
            definir un estándar de programación y participar en la investigación y toma de decisiones sobre tecnologías a emplear.
            Fue donde más aprendí sobre ingeniería de software, trato con clientes y organización de proyectos.
            """
            """
            Startup formed by me and a team of capable schoolfellows.
            Our main projects were a successful music blog and a small application to manage invoices.
            My tasks included programming in Vue and React, taking part in meetings with clients aimed at understanding their requirements and proposing solutions,
            define a programming standard and participate in the research and decision-making around our tech stack.
            Here I learned the most about software engineering, project management and how to have agreements with clients.
            """
        )
    , Job (always "SoldAI")
        (SimpleDate Time.Jul 2019)
        (Just <| SimpleDate Time.Sep 2020)
        (Language.translated "Desarrollador Web Frontend" "Frontend Web Developer")
        (Language.translated
            """
            Empresa dedicada al desarrollo de inteligencia artificial para la creación de chatbots.
            Mi principal labor fue la programación en Vue de una aplicación web que permitía personalizar y desplegar chatbots en distintas plataformas.
            A pesar de que ya había programado en entornos académicos, trabajar aquí aumentó significativamente mis habilidades técnicas
            y me ayudó a definir mi estilo de programación.
            """
            """
            Company dedicated to the development of artificial intelligence to create chatbots.
            My main labour was to program a Vue application to personalize and deploy chatbots in multiple platforms.
            Although I have programmed in academic environments, here I learned in depth about web development,
            the personalization of my work environment, git, testing and other basic programming skills.
            """
        )
    ]


type alias Project =
    { title : Language.Language -> String
    , url : String
    , year : Int
    , description : Language.Language -> String
    }


projects : List Project
projects =
    [ Project (always "MiObra Export App")
        "https://apps.microsoft.com/detail/XPFF9W7DQL962Z"
        2022
        (Language.translated
            """
            Aplicación WPF para migrar proyectos hechos en una aplicación de terceros a MiObra.
            Siendo casi completamente de mi autoría, para este proyecto creé herramientas que facilitaron la
            encriptación híbrida y una librería declarativa para consultar datos almacenados en CTEs recursivas.
            """
            """
            WPF application to migrate projects made with a third party app to MiObra.
            I was tasked to develop almost the entire application, it took me around three months to complete.
            The tools I developed for that project include hybrid encryption and a declarative library to query recursive CTEs.
            """
        )
    , Project (always "MiObra")
        "https://www.miobra.mx/"
        2022
        (Language.translated
            """
            Aplicación para facilitar la administración a nivel empresarial de obras de construcción.
            Fui desarrollador para la versión web y el backend, usando un stack de React y Django.
            Participé en reuniones con clientes, la toma de decisiones técnicas y muchos de mis aportes facilitaban la mantenibilidad de la aplicación.
            """
            """
            App to facilitate the business-level management of constructions.
            I was a developer for the web version and the backend, with a stack of React and Django.
            I took part in meetings with clients, technical decision-making and a lot of my contributions helped with the maintainability of the app.
            """
        )
    , Project (always "Dark Impala")
        "https://darkimpala.com/"
        2020
        (Language.translated
            """
            Blog de música desarrollado con Wordpress y Vue.js.
            En este proyecto me familiaricé con aspectos del desarrollo de software que van más allá de la programación, como el diseño UI/UX,
            optimización de SEO, trato directo con clientes, configuración de hosting, dominio y certificados SSL, etc.
            """
            """
            Music blog developed with Wordpress and Vue.js.
            In this project I practiced skills related to software development apart from just coding, like UI/UX design,
            SEO optimization, direct contact with clients, hosting, domain and SSL configuration, etc.
            """
        )
    ]


type alias Study =
    { title : Language -> String
    , institution : String
    , start : SimpleDate
    , end : SimpleDate
    }


education : List Study
education =
    [ Study (Language.translated "Licenciatura en Ingeniería de Software" "Bachelor of Software Engineering")
        "UADY"
        (SimpleDate Time.Aug 2017)
        (SimpleDate Time.Dec 2023)
    , Study (Language.translated "Cursos de arquitectura reactiva" "Reactive architecture courses")
        "Lightbend Academy"
        (SimpleDate Time.May 2021)
        (SimpleDate Time.Jul 2021)
    ]


proficientSkills : List (Language -> String)
proficientSkills =
    [ always "JavaScript"
    , always "TypeScript"
    , always "ReactJS"
    , always "Python"
    , always "Elm"
    , always "git"
    , always "CSS"
    ]


familiarSkills : List (Language -> String)
familiarSkills =
    [ always "Elixir"
    , always "Java"
    , always "Next.js"
    , always "SQL"
    , always ".NET"
    , always "MongoDB"
    , always "Wordpress"
    , Language.translated "Microservicios" "Microservices"
    , always "Event Sourcing"
    , always "CQRS"
    ]


type alias SmallProject =
    { name : Language -> String
    , url : String
    }


smallProjects : List SmallProject
smallProjects =
    [ SmallProject (always "Mask") "https://github.com/Chesare22/mask"
    , SmallProject (Language.translated "Buscaminas" "Minesweeper") "https://github.com/Chesare22/Buscaminas-DIY"
    , SmallProject (always "Shuffle Textlines.js") "https://github.com/Chesare22/shuffle-textlines.js"
    , SmallProject (always "@sumerian/eslint-config") "https://www.npmjs.com/package/@sumerian/eslint-config"
    , SmallProject (Language.translated "Aplicación de Fireship en Elm" "Fireship App in Elm") "https://github.com/Chesare22/Fireship-app-in-elm"
    , SmallProject (always "Dark Impala") "https://darkimpala.com/"
    , SmallProject (always "Blob Escape") "https://itch.io/jam/gmtk-2021/rate/1086701"
    , SmallProject (always "3 features de JavaScript que aprendí fuera de la escuela")
        "https://medium.com/soldai/3-features-de-javascript-que-aprend%C3%AD-fuera-de-la-escuela-978e009c9201"
    , SmallProject (always "Petite Resort") "https://www.petiteresort.mx/"
    , SmallProject (Language.translated "Programa de votos usando MVC" "Votes system using MVC")
        "https://github.com/Chesare22/Semestre-5/tree/arquitectura/Votes/src/main/java"
    ]


type alias Book =
    { title : String
    , author : String
    , description : Language -> String
    }


books : List Book
books =
    [ Book "Domain Modeling Made Functional"
        "Scott Wlaschin"
        (Language.translated
            "Esencial para cualquier ingeniero de software interesado en la programación funcional. Enseña cómo sacar el máximo provecho al sistema de tipos algebraicos como herramienta de \"documentación ejecutable\", describiendo de forma fiel y actualizada las características, relaciones y restricciones de cada entidad."
            "Essential for any software engineer interested in functional programming. It teaches how to get the most out of the algebraic type system as \"executable documentation\", describing in an accurate and up-to-date manner the characteristics, relationships and restrictions of each entity."
        )
    , Book "You Don't Know JS (book series)"
        "Kyle Simpson"
        (Language.translated
            "Marcó un antes y un después en mi carrera como programador, pues fue la primera vez que entendí a fondo un lenguaje. Me permitió programar con confianza, lo cual tuvo un impacto positivo en mi velocidad al programar y en la calidad de mi código. La principal lección que me dejó fue la importancia de entender bien una tecnología antes de usarla."
            "It marked a turning point in my career as a programmer because it was the first time I deeply understood a language. It allowed me to program with confidence, which had a positive impact on my speed and the quality of my code. The main lesson I learned from this book series is the importance of understanding any technology well before using it."
        )
    , Book "CSS Secrets"
        "Lea Verou"
        (Language.translated
            """
            CSS es un lenguaje que requiere de mucha práctica y memorización, donde son comunes las propiedades diseñadas para interactuar con otras.
            CSS Secrets es un handbook que recopila diversos patrones, al mismo tiempo que explica a fondo las propiedades involucradas.
            Es una excelente referencia que he usado en múltiples ocasiones para progresar en mi trabajo.
            """
            """
            CSS is a language that requires a lot of practice and memorization, where it's common to find properties designed to interact with each other.
            CSS Secrets is a handbook that collects a wide array of patterns and deeply explains the properties involved in them.
            It's an excellent reference that has gotten me unstock more than once.
            """
        )
    , Book "JavaScript: The Good Parts"
        "Douglas Crockford"
        (Language.translated
            """
            
            """
            """
            
            """
        )
    , Book "Programming Elixir"
        "Dave Thomas"
        (Language.translated
            """
            
            """
            """
            
            """
        )
    , Book "Functional-Light JavaScript"
        "Kyle Simpson"
        (Language.translated
            """
            
            """
            """
            
            """
        )
    , Book "Python Distilled"
        "David M. Beazley"
        (Language.translated
            """
            
            """
            """
            
            """
        )
    ]
