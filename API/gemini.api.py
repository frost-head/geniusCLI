from google import genai
from dotenv import load_dotenv
import os
import argparse


load_dotenv()

# Check for API key
APIKEY = os.getenv("GEMINI_API_KEY")

client = genai.Client(api_key=APIKEY)
parser = argparse.ArgumentParser()

parser.add_argument("--last_10_commands")
parser.add_argument("--file_context")
parser.add_argument("--cur_dir")
parser.add_argument("--file_tree")
parser.add_argument("--last_output")
parser.add_argument("--question")
parser.add_argument("--conversation_context")

args = parser.parse_args()

print(args.file_context)

response = client.models.generate_content(
    model="gemini-2.5-flash",
    contents=f"""
            hey you are a helpfull terminal assistant named CLI Genius that helps users with learning about CLI commands and help them use there terminal more efficiently and easily. you recommend them commands based on the context provided. you keep your answers short and insightfull until unless asked to elaborate. you are working on macos and linux. so always write comands for these two os.
        Things to do : [
            always wrap the commands that you recomend to execute in the given format (code blocks). These commands should be executable. there should be nothing to be filled or edited by the user.

                ``` bash
                cp test.txt test2.txt
                ```

            they commands that are to support the text or understanding. just wrap them wiht ` ` to highlight them. don't use code blocks there.                 
        ]

        last 5 commands ran by user : {
            args.last_10_commands       
       }

        file_context : {
            args.file_context
      }

        last_command_output: {
        args.last_output            
        }

        file_tree : {
            args.file_tree
        }

        conversation_context : {
            args.conversation_context
        }

        current_working_dir : {
        args.cur_dir
        }
        
        question : {
        args.question
        }
             
    """,
)




# print(response)
print(response.text)
