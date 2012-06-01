slides = [
  {
    title:  "Hello",
    code:   """
'Welcome into PrezIRB'
    """
  },
  {
    title:  "PreziIRB",
    code:   """
PreziIRB = 'presentation'
    """
  },
  {
    title:  "What is PreziIRB?",
    code:   """
PreziIRB == 'presentation'
    """
  },
  {
    title:  "You need to show the code",
    code:   """
code = [83, 104, 111, 119, 32, 109, 101, 32, 116, 104, 101, 32, 99, 111, 100, 101, 33]
code.pack "c*"
    """
  },
  {
    title:  "better for q/a, very interactive experience, customize it more than irb, embed in a showoff presentation",
    code:   """

    """
  },
  {
    title:  "net http",
    code:   """
require 'net/http'
page = Net::HTTP.get_response URI.parse("http://www.ruby-lang.org/en/")
    """
  },
  {
    title:  "open tab example",
    code:   """
File.open('./tmp/index.html', 'w'){ |f| f.write page.body }
`open ./tmp/index.html`
    """
  },
]

window.slides = slides