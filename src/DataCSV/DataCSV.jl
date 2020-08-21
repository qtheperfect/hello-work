

module DataCSV
# Use CSV files to store huge data
# Where colomn :Data stores large data as Strings, while all other columns store keys.

export CSVInfo, dict2Row, row2File, file2Rows,  findRows, keyExists, file2Keys 
using DataFrames
using CSV
using Dates

struct CSVInfo
    keys::Array{Symbol, 1}
    keytypes::Dict{Symbol, Type}
    fileName::String
end

function CSVInfo(sample::Union{Dict, NamedTuple}, fileName::String)
    keytypes = Dict([k => typeof(sample[k]) for k in keys(sample)])
    CSVInfo(
        collect(keys(sample)),
        merge(keytypes, Dict(:Data=> String)),
        fileName
    )
end

function dict2Row(d::Union{Dict, NamedTuple}, data::Any, info::CSVInfo)
    df=DataFrame()
    for k in info.keys
        df[!, k] = [d[k]]
    end
    df[!, :Data]=[data]
    df
end

function row2File(t::DataFrame, info::CSVInfo)
    if (! isfile(info.fileName))
        CSV.write(info.fileName, t) 
    else
        CSV.write(info.fileName, t; append=true)
    end
end


function file2Rows(info::CSVInfo)
    rawTable=CSV.Rows(info.fileName; types = info.keytypes)
    rawTable
end

function file2Keys(info)
    if (! isfile(info.fileName))
        return [ ]
    end
    keyColumns = CSV.Rows(info.fileName; select=info.keys, types = info.keytypes) 
    [ Dict([ k => r[k] for k in keys(r)]) for r in keyColumns]
end


function goodRow(key::Union{Dict, NamedTuple}, row)
        for k in keys(key)
            if (key[k]  !=  row[k])
                return false
            end
        end
        return true
end

function useRow(r; nokeys = false)
    data=r[:Data]
    try
        data = eval(Meta.parse(r[:Data]))
    catch
        println("data as pure String!")
    end
    if (nokeys)
        data
    else
        keyDict = Dict([k => r[k] for k in keys(r) if k != :Data])
        merge(keyDict, Dict(:Data => data))
    end
end

function findRows(key::Dict, rows; iter = false, nokeys = true)
    gen = (useRow(r; nokeys = nokeys) for r in rows if goodRow(key, r))
    if (iter)
        Iterators.Stateful(gen)
    else
        collect(gen)
    end
end

function findRows(f::Function, rows; iter = false, nokeys = true)
    gen = (useRow(r, nokeys = nokeys) for r in rows if f(r))
    if (iter)
        Iterators.Stateful( gen )
    else 
        collect(gen)
    end
end

function keyExists(keys::Union{Dict, NamedTuple}, rows)
    for r in rows
        if  (goodRow(keys, r))
            return true
        end
    end
    return false
end

function getKeyChecker(info)
    keysInFile = [] 
    if ( isfile(info.fileName))
        println("Found a data file!")
        keysInFile = file2Keys(info)
        println("Finished reading the data file!, $(length(keysInFile)) Items")
    end
    k -> keyExists(k, keysInFile)
end

end # end module
                                        

          
 # ======================use-like-this======================>

                                        
# using .DataCSV
# using DataFrames

# DC = DataCSV


# sample=Dict(
#         :x => 3,
#         :y => 4
# )
# info = DC.CSVInfo(sample, "output/large.csv")
 
# function gigantic( )
#     keysInFile= DC.file2Keys(info)
#     println(length(keysInFile))
#     for x in 1:20001
#         for y in 1:20002
#             keydic = (x = x, y = y)
#             if (DC.keyExists(keydic, keysInFile))
#                 continue
#             end
#             println(keydic)
#             df = DC.dict2Row(keydic, Dict(:square=>sqrt((x^2 + y^2)/2.0), :matrix=>rand(x % 5 +1 , y % 12 + 1)), info)
#             DC.row2File(df, info)
#         end
#     end
# end

# function getSmall( )
#     rows = DC.file2Rows(info)
#     allKeys = DC.file2Keys(info)
#     println(length(allKeys))
#     goodRows = DC.findRows(r -> r.x + r.y == 1111, rows)
#     for r in goodRows
#         println(r)
#     end
# end

# # gigantic()
# getSmall()

