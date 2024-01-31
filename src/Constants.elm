module Constants exposing
    ( Book
    , BookCompletion(..)
    , ContactInfo
    , Experience
    , Highlight(..)
    , SimpleDate
    , books
    , contactList
    , email
    , familiarSkills
    , jobs
    , learningSkills
    , name
    , phone
    , proficientSkills
    , studies
    )

import FeatherIcons
import Language exposing (..)
import Material.Icons as Filled
import Material.Icons.Types exposing (Coloring(..), Icon)
import Phone
import Svg.Styled
import Time


name : String
name =
    "César González"


email : String
email =
    "ces.gonzalezortega@gmail.com"


phone : Phone.InternationalPhone
phone =
    Phone.InternationalPhone
        52
        1
        9993912495


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
    , { href = "https://www.linkedin.com/in/cgonzalez22/"
      , text = "/cgonzalez22"
      , icon =
            Svg.Styled.fromUnstyled
                (FeatherIcons.linkedin
                    |> FeatherIcons.withSize (toFloat iconSize)
                    |> FeatherIcons.toHtml []
                )
      }
    ]


proficientSkills : List (Language -> String)
proficientSkills =
    [ always "JavaScript"
    , always "HTML"
    , always "(S)CSS"
    ]


familiarSkills : List (Language -> String)
familiarSkills =
    [ always "Elm"
    , always "C#"
    , translated "Programación funcional" "Functional programming"
    , always "Git"
    , always "React JS"
    , always "Vue"
    , always "Figma"
    , translated "Googlear" "Googling"
    ]


learningSkills : List (Language -> String)
learningSkills =
    [ always "Elixir"
    , always "Event sourcing"
    , always "CQRS"
    , translated "Microservicios" "Microservices"
    , translated "Diseño guiado por el dominio" "Domain-driven design"
    , always "MongoDB"
    , always "SQL"
    ]


type alias Experience =
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


jobs : List Experience
jobs =
    [ Experience (always "MID Software")
        (SimpleDate Time.Mar 2022)
        (Just <| SimpleDate Time.Aug 2023)
        (Language.translated "Desarrollador Web Full-Stack" "Full-Stack Web Developer")
        (Language.translated
            "Cupcake ipsum dolor sit amet fruitcake chocolate bar powder. Soufflé gingerbread lemon drops icing danish gingerbread bonbon. Candy pie marzipan chocolate bar liquorice dragée pudding candy. Caramels lollipop chocolate bar dessert cotton candy sweet."
            "Cat ipsum dolor sit amet, stare at the wall, play with food and get confused by dust, making sure that fluff gets into the owner's eyes. Prow?? ew dog you drink from the toilet, yum yum warm milk hotter pls, ouch too hot. Gate keepers of hell murr i hate humans they are so annoying."
        )
    , Experience (always "Coatí Labs")
        (SimpleDate Time.Jan 2021)
        (Just <| SimpleDate Time.Apr 2021)
        (Language.translated "Desarrollador Web Frontend" "Frontend Web Developer")
        (Language.translated
            "Empresa de programación web donde me familiaricé con algunos eventos de scrum. Mi labor principal era el desarrollo de páginas web con React y TypeScript."
            "At vero eos et accusamus et iusto odio dignissimos ducimus qui blanditiis praesentium voluptatum deleniti atque corrupti quos dolores et quas molestias excepturi sint occaecati cupiditate non provident, similique sunt in culpa qui officia deserunt mollitia animi, id est laborum et dolorum fuga. Et harum quidem rerum facilis est et expedita distinctio. Nam libero tempore, cum soluta nobis est eligendi optio cumque nihil impedit quo minus id quod maxime placeat facere possimus, omnis voluptas assumenda est, omnis dolor repellendus."
        )
    , Experience (always "Sumerian")
        (SimpleDate Time.Jun 2020)
        (Just <| SimpleDate Time.Jul 2021)
        (Language.translated "Ingeniero de Software" "Software Engineer")
        (Language.translated
            "Sumerian hace aplicaciones web. En cada proyecto experimentábamos con nuevas herramientas y metodologías."
            "Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo. Nemo enim ipsam voluptatem quia voluptas sit aspernatur aut odit aut fugit, sed quia consequuntur magni dolores eos qui ratione voluptatem sequi nesciunt. Neque porro quisquam est, qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit, sed quia non numquam eius modi tempora incidunt ut labore et dolore magnam aliquam quaerat voluptatem."
        )
    , Experience (always "SoldAI")
        (SimpleDate Time.Jul 2019)
        (Just <| SimpleDate Time.Sep 2020)
        (Language.translated "Desarrollador Web Frontend" "Frontend Web Developer")
        (Language.translated
            "SoldAI es una empresa yucateca dedicada a la inteligencia artificial. Ayudé en pruebas, desarrollo, mantenimiento y documentación de varios proyectos."
            "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."
        )
    ]


studies : List Experience
studies =
    [ Experience (Language.translated "Licenciatura en Ingeniería de Software" "Bachelor of Software Engineering")
        (SimpleDate Time.Aug 2017)
        Nothing
        (always "UADY")
        (Language.translated
            "Carrera que enseña cómo aplicar ingeniería en la producción de software. También  conlleva aprender programación, pruebas, requisitos y otras habilidades."
            "Career that teaches how to apply engineering to the production of software. It also involves learning programming, testing, requirements and other abilities."
        )
    , Experience (Language.translated "Cursos sobre Arquitectura Reactiva" "Courses about Reactive Architecture")
        (SimpleDate Time.May 2021)
        (Just <| SimpleDate Time.Jul 2021)
        (always "Lightbend Academy")
        (Language.translated
            "Tomé seis cursos en línea donde aprendí lo básico sobre sistemas reactivos, microservicios, DDD, mensajes distribuidos y event sourcing."
            "I took six online courses where I learned the basics of reactive systems, microservices, DDD, distributed messaging and event sourcing."
        )
    ]


type alias Book =
    { title : String
    , author : String
    , completion : BookCompletion
    , highlight : Highlight
    }


type BookCompletion
    = Finished
    | Midway Int


type Highlight
    = Regular
    | Highlighted


books : List Book
books =
    [ Book "JavaScript: The Good Parts"
        "Douglas Crockford"
        Finished
        Highlighted
    , Book "You Don't Know JS (book series)"
        "Kyle Simpson"
        (Midway 85)
        Regular
    , Book "Domain Modeling Made Functional"
        "Scott Wlaschin"
        (Midway 50)
        Highlighted
    , Book "CSS Secrets"
        "Lea Verou"
        (Midway 25)
        Regular
    , Book "Programming Elixir"
        "Dave Thomas"
        (Midway 70)
        Highlighted
    , Book "Functional-Light JavaScript"
        "Kyle Simpson"
        Finished
        Regular
    , Book "Effective TypeScript"
        "Dan Vanderkam"
        (Midway 20)
        Regular
    , Book "MongoDB: The Definitive Guide"
        "Kristina Chodorow"
        (Midway 20)
        Regular
    , Book "Python Distilled"
        "David M. Beazley"
        (Midway 15)
        Regular
    ]
